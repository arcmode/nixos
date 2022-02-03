#!/usr/bin/env python

from flask import Flask, jsonify
from lib.common.is_efi import is_efi
from lib.list_disks import list_disks

app = Flask(__name__)


@app.route('/system-info')
def get_system_info():
    return jsonify({
        'is_efi': is_efi(),
        'disks': list_disks(),
    })


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8080)
