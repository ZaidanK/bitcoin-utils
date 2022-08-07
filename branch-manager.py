import pygit2

import os
import re
import sys

from argparse import ArgumentParser

cli = ArgumentParser()
subparsers = cli.add_subparsers(dest="subcommand")


def argument(*name_or_flags, **kwargs):
    """Convenience function to properly format arguments to pass to the
    subcommand decorator.
    """
    return (list(name_or_flags), kwargs)


def subcommand(args=[], parent=subparsers):
    """Decorator to define a new subcommand in a sanity-preserving way.
    The function will be stored in the ``func`` variable when the parser
    parses arguments so that it can be called directly like so::
        args = cli.parse_args()
        args.func(args)
    Usage example::
        @subcommand([argument("-d", help="Enable debug mode", action="store_true")])
        def subcommand(args):
            print(args)
    Then on the command line::
        $ python cli.py subcommand -d
    """
    def decorator(func):
        parser = parent.add_parser(func.__name__, description=func.__doc__)
        for arg in args:
            parser.add_argument(*arg[0], **arg[1])
        parser.set_defaults(func=func)
    return decorator

BITCOIN_CHAIN = ["test","main", "regtest"]

def get_branches():
    return pygit2.Repository(path=os.getenv('GITDIR')).branches.local



@subcommand([argument("branches", help="Name",action="store_true")])
def branches(args):
    print(list(get_branches()))
    
@subcommand([argument("context", help="Context")])
def context(args):
    if "::" in args.context:
        cmd = []
        context = args.context.split("::")
        if context[0] in BITCOIN_CHAIN:
            cmd.append(f"export BITCOIN_CHAIN={context[0]};")
        else:
            print(f"echo {context[0]} is an 'Invalid chain'")
            
        filtered_branches = [branch for branch in get_branches() if context[1] in branch]
        if len(filtered_branches) > 1:
            print(f"echo Found more than one branch matching {context[1]}")

        else:
            cmd.append(f"export BRANCH={filtered_branches[0]};")
            
        print("".join(cmd))
            


if __name__ == "__main__":
    args = cli.parse_args()
    if args.subcommand is None:
        cli.print_help()
    else:
        args.func(args)