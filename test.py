from blockchain import Blockchain, Block
from time import time

tmp = Blockchain()
tmp.addBlock(Block(str(int(time())), ({"from": "John", "to": "Bob", "amount": 100})))
# print(tmp.__repr__())
print(tmp.isValid())
lastBlock = tmp.getLastBlock()
lastBlock.data = {"from": "John", "to": "Bob", "amount": 100}
print(tmp.isValid())