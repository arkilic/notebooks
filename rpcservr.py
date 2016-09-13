
from __future__ import print_function, absolute_import
import numpy as np
from pvaccess import (PvObject, STRING, DOUBLE, 
                      NtTable, NtType, PvInt, RpcServer)
from collections import OrderedDict
from pymongo import MongoClient

class RPCResponseHandler:
    def __init__(self, host, port):
        self.srv = RpcServer()
        self.host = host
        self.port = port
    
    @property
    def conn(self):
        return MongoClient(self.host, self.port)
    @property
    def database(self):
        return self.conn.mockdata
    
    def make_mock_table(self):
        cols = {'column0' : [DOUBLE], 
        'column1' : [DOUBLE], 
        'column2' : [DOUBLE]}
        colstruct = OrderedDict(sorted(cols.items(), 
                                       key=lambda t: t[0]))
        struct = OrderedDict([('labels', [STRING]), 
                              ('value', colstruct)])
        pvobj = PvObject(struct)
        pvobj.setScalarArray('labels', ['x', 'y', 'z'])
        return pvobj
    
    def get_by_id(self, x):
        print("here I am at the query")
        id = x.getString('id')
        # self.database.find({'id': id})
        tbl = self.make_mock_table()
        tbl.setStructure({'column0': [0, 1, 2, 3, 5],
                 'column1': [4, 6, 7, 8, 9],
                 'column2': [10, 11, 12, 13, 14]})
        return tbl
    
    def get_by_time(self, x):
        print("here I am at the query")
        id = x.getDouble('time')
        # self.database.find({'id': id})
        tbl = self.make_mock_table()
        tbl.setStructure({'column0': [0, 1, 2, 3, 5],
                 'column1': [4, 6, 7, 8, 9],
                 'column2': [10, 11, 12, 13, 14]})
        return tbl
    
    def register_listen(self):
        self.srv.registerService('get_by_id', self.get_by_id)
        self.srv.registerService('get_by_time', self.get_by_time)
        self.srv.listen()

r = RPCResponseHandler(host='localhost', port=27017)

r.database

r.register_listen()

def make_mock_table():
    cols = {'column0' : [DOUBLE], 
    'column1' : [DOUBLE], 
    'column2' : [DOUBLE]}
    colstruct = OrderedDict(sorted(cols.items(), 
                                   key=lambda t: t[0]))
    struct = OrderedDict([('labels', [STRING]), 
                          ('value', colstruct)])
    pvobj = PvObject(struct)
    pvobj.setScalarArray('labels', ['x', 'y', 'z'])
    return pvobj
tbl = make_mock_table()
tbl.getStructure()
tbl.setStructure({'column0': [0.0]})
          


