import os, ptvsd

# Only attach the debugger when we're the Django that deals with requests
if os.environ.get('RUN_MAIN') or os.environ.get('WERKZEUG_RUN_MAIN'):
    ptvsd.enable_attach(address=('0.0.0.0', 3000), redirect_output=True)
