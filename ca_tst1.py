from kaitaistruct import KaitaiStream, BytesIO
from python_pickle import *

import pickle

# kaitai structures
from te_ansi_content_2310 import *
from te_ansi_content_2311 import *
from te_ansi_content_55 import *

dataUri = 'dump_TE_binary_20201006-20201007.pickle'

# deserializes dump
data = pickle.load(open(dataUri, "rb"))

# now I have a list, where each element of the list a sequence of bytes
print(type(data))
# <class 'list'>

print(type(data[0]))
# <class 'bytes'>

# now I can parser each sequence of bytes into a kaitai  structure, for example:
raw = data[0]
table55 = TeAnsiContent55(KaitaiStream(BytesIO(raw)))
print(table55.year)
# 48
print(table55.weekday)
# 0

# But, how to know what kaitai structure to use ?, there are others like TeAnsiContent2310 and TeAnsiContent2311.
