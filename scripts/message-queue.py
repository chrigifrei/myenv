#!/usr/bin/env python
DESC = "Adds/Removes messages to/from an event queue"
EPILOG = """
Examples:

  # Add a single message to the queuefile myqueue.db
  %(prog)s -fmyqueue.db add --instance P --job myjob --event STARTED --message "Some message"

  %(prog)s -fmyqueue.db add -j '{"instance": "P", "job": "myjob", "event": "STARTED", "message": "Some message"}'

  # Print queue length
  %(prog)s -fmyqueue.db length

  # Print queue contents as JSON (max 100 items)
  %(prog)s -fmyqueue.db list -i100

  # Print queue contents as JSON displaying time in local time
  %(prog)s -fmyqueue.db list -t LOCALTIME

  # You can pretty print using the "jq" utility:
  %(prog)s -fmyqueue.db list -i100 | jq .

  # Remove single item from the queue and print it as JSON
  %(prog)s -fmyqueue.db remove

  # Remove single item from the queue, print it as JSON and displaying time as unixepoche
  %(prog)s -fmyqueue.db remove -t EPOCHE

  # Remove 10 items from the queue at once and print them as JSON, the first
  # item will be oldest queue item
  %(prog)s -fmyqueue.db remove -i10

"""

import os
import sys
import textwrap
try:
    import sqlite
except:
    import sqlite3 as sqlite

try:
    import json
except ImportError:
    # Backwards compatibility with Python 2.4. See
    # <http://stackoverflow.com/questions/3291682/json-module-for-python-2-4>
    # Using version 2.1.0 of simplejson (copied from Git checkout)
    import simplejson as json

# requires python >=2.7
import argparse

# ========================================================================
_VERBOSITY         = 0
_DEFAULT_DB_FILE   = 'msg-queue.sqlite'
_DEFAULT_MAX_ITEMS = 10
_SELECT_FULL_ROW   = ""


def die(msg, exit_code=1):
    ''' die cleanly '''

    sys.stderr.write('%s\n' % msg)
    sys.exit(exit_code)


def debug(msg, args=None):
    if _VERBOSITY > 1:
        if args is None:
            print msg
        else:
            print msg % args

# ========================================================================

def create_db(filename):
    con = None
    cur = None
    try:
        con = sqlite.connect(filename)
        cur = con.cursor()
    except Exception:
        die("Cannot open %s" % filename, 1)

    try:
        # TODO: Also add a schema version table?
        cur.execute("""CREATE TABLE IF NOT EXISTS messages(
                         id        INTEGER PRIMARY KEY,
                         timestamp REAL DEFAULT (strftime('%J', 'now')),
                         instance  TEXT,
                         job       TEXT,
                         event     TEXT,
                         message   TEXT
                    )""")
        cur.execute("""CREATE INDEX IF NOT EXISTS messages_by_date
                         ON messages(timestamp)""")
    except Exception, e:
        print e

    try:
        con.commit()
    except:
        print "Commit failed"

    try:
        con.close()
    except:
        pass


def open_db(dbfilename):
    if not os.path.isfile(dbfilename):
        create_db(dbfilename)

    con = None
    cur = None

    debug("Opening DB: %s", dbfilename)
    try:
        con = sqlite.connect(dbfilename)
        cur = con.cursor()
    except Exception:
        die("Cannot open %s" % filename)

    return con, cur


def enqueue(dbfilename, instance, job, event, message):
    con, cur = open_db(dbfilename)
    try:
        stmt = "INSERT INTO messages(instance, job, event, message) VALUES (?, ?, ?, ?)"
        debug("inserting: %s, (%s, %s, %s, %s)",
              (stmt, instance, job, event, message))
        cur.execute(stmt, (instance, job, event, message))
        con.commit()
        con.close()
    except Exception, e:
        die("DB problem: %s" % e)


def row_as_msg(row):
    # SQLite doesn't enforce types, so we try to parse ids as int.
    return {'_id': int(row[0]),
            'timestamp': row[1],
            'instance': row[2],
            'job': row[3],
            'event': row[4],
            'message': row[5]}


def queue_length(dbfilename):
    qlen = 0
    con, cur = open_db(dbfilename)
    try:
        stmt = "SELECT count(id) FROM messages"
        debug("Executing: %s", stmt)
        cur.execute(stmt)

        rows = cur.fetchone()
        qlen = rows[0]

        con.close()
    except sqlite.Error, e:
        die("DB problem: %s" % e)

    print qlen

def set_timeformat(timeformat):
    
    global _SELECT_FULL_ROW

    if timeformat == 'EPOCHE':
        format = "strftime('%s', timestamp)"

    elif timeformat == 'LOCALTIME':
        format = "datetime(timestamp, 'localtime')"

    else:
        format = "strftime('%Y-%m-%dT%H:%M:%fZ', timestamp)"

    _SELECT_FULL_ROW = "SELECT id, %s as timestamp, instance, job, event, message " % format

def list_queue(dbfilename, maxitems=_DEFAULT_MAX_ITEMS):
    msgs = None
    con, cur = open_db(dbfilename)
    try:
        stmt = _SELECT_FULL_ROW + "FROM messages"
        debug("Executing: %s", stmt)
        cur.execute(stmt)

        rows = cur.fetchmany(maxitems)
        msgs = [ row_as_msg(row) for row in rows ]

        con.close()
    except sqlite.Error, e:
        die("DB problem: %s" % e)

    print json.dumps(msgs, indent=None)


def dequeue(dbfilename, maxitems=_DEFAULT_MAX_ITEMS):
    msgs = None
    con, cur = open_db(dbfilename)
    try:
        stmt = _SELECT_FULL_ROW + "FROM messages ORDER BY timestamp ASC"
        cur.execute(stmt)

        rows = cur.fetchmany(maxitems)
        msgs = [ row_as_msg(row) for row in rows ]

        ids = [ str(msg['_id']) for msg in msgs ]

        # No injection possible, because all strings in "ids" represent numbers
        del_stmt = "DELETE FROM messages WHERE id IN (%s)" % ','.join(ids)
        cur.execute(del_stmt)

        con.commit()
        con.close()
    except sqlite.Error, e:
        print type(e)
        die("DB problem: %s" % e)

    if msgs:
        print json.dumps(msgs)


def parse_json(jsonstr):
    try:
        data = json.loads(jsonstr)
    except:
        die("Could not parse JSON: %s" % jsonstr)

    return data.get("instance"), data.get("job"), data.get("event"), data.get("message")


def command_add(args):
    instance = None
    job = None
    event = None
    message = None

    if args.json is not None:
        instance, job, event, message = parse_json(args.json)
    else:
        instance = args.instance
        job = args.job
        event = args.event
        message = args.message

    # Validate args
    if instance is None:
        die("Message field \"instance\" is required")
    if job is None:
        die("Message field \"job\" is required")
    if event is None:
        die("Message field \"event\" is required")
    if message is None:
        message = ''

    dbfilename = args.file
    enqueue(dbfilename, instance, job, event, message)

def command_list(args):
    dbfilename = args.file
    set_timeformat(args.timeformat)
    list_queue(dbfilename, args.max_items)

def command_length(args):
    dbfilename = args.file
    queue_length(dbfilename)

def command_remove(args):
    dbfilename = args.file
    set_timeformat(args.timeformat)
    dequeue(dbfilename, args.max_items)


# ========================================================================
# Argument parsing

if __name__ == '__main__':

    parser = argparse.ArgumentParser(
        prog="message-queue",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=DESC,
        epilog=textwrap.dedent(EPILOG)
    )
    parser.add_argument(
        "-v", "--verbose", action="store_true",
        help="Use verbose output")
    parser.add_argument(
        "-f", "--file", type=str, metavar="QUEUEFILE",
        default=_DEFAULT_DB_FILE,
        help="Queue file to use. Default: " + _DEFAULT_DB_FILE)

    subparsers = parser.add_subparsers(
        help="Available commands")

    parser_add = subparsers.add_parser(
        "add", help="Add a single message to the queue")
    parser_add.set_defaults(func=command_add)
    parser_add.add_argument(
        "-j", "--json", type=str, metavar="[-|JSON]",
        help=""" Specify data as JSON. If argument is "-", then the JSON data must
        be provided on standard input. The JSON data must be a single object
        containing string fields "instance", "job", "event". The "message" field is
        optional and defaults to an empty string.
        Example: {\"instance\": \"P\", "job": "myjob", "event": "STARTED",
        "message": "myjob was started"}""")
    parser_add.add_argument(
        "--instance", type=str, metavar="INSTANCE")
    parser_add.add_argument(
        "--job", type=str, metavar="JOB")
    parser_add.add_argument(
        "--event", type=str, metavar="EVENT_TYPE")
    parser_add.add_argument(
        "--message", type=str, metavar="MESSAGE")

    parser_list = subparsers.add_parser(
        "list", help="List queue contents")
    parser_list.set_defaults(func=command_list)
    parser_list.add_argument(
        "-i", "--max-items", type=int, default=_DEFAULT_MAX_ITEMS,
        help="Maximum number of items to list")
    parser_list.add_argument(
        '-t', '--timeformat', choices=['UTC', 'EPOCHE', 'LOCALTIME'], default='UTC',
        help='Timestamp format')

    parser_length = subparsers.add_parser(
        "length", help="Print queue length")
    parser_length.set_defaults(func=command_length)

    parser_remove = subparsers.add_parser(
        "remove", help="Remove items from the queue")
    parser_remove.set_defaults(func=command_remove)
    parser_remove.add_argument(
        "-i", "--max-items", type=int, default=_DEFAULT_MAX_ITEMS,
        help="Maximum number of items to remove")
    parser_remove.add_argument(
        '-t', '--timeformat', choices=['UTC', 'EPOCHE', 'LOCALTIME'], default='UTC',
        help='Timestamp format')

    # parse the args and call the appropriate command function
    args = parser.parse_args()
    if args.verbose:
        _VERBOSITY = 2

    # debug('test')

    args.func(args)
