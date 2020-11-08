# @version ^0.2.0

beneficiary: public(address)
auctionStart: public(uint256)
auctionEnd: public(uint256)

highestBidder: public(address)
highestBid: public(uint256)

pendingReturns: public(HashMap[address, uint256])

@external
def __init__(_beneficiary: address, _bidding_time: uint256):
    self.beneficiary = _beneficiary
    self.auctionStart = block.timestamp
    self.auctionEnd = self.auctionStart + _bidding_time

@external
@payable
def bid():
    assert block.timestamp < self.auctionEnd
    assert msg.value > self.highestBid
    self.pendingReturns[self.highestBidder] += self.highestBid
    self.highestBidder = msg.sender
    self.highestBid = msg.value