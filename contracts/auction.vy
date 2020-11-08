# @version ^0.2.7

beneficiary: public(address)
auctionStart: public(uint256)
auctionEnd: public(uint256)

highestBidder: public(address)
highestBid: public(uint256)

ended: public(bool)

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

@external
def withdraw():
    pending_amount: uint256 = self.pendingReturns[msg.sender]
    self.pendingReturns[msg.sender] = 0
    send(msg.sender, pending_amount)

@external
def end_auction():
    assert block.timestamp > self.auctionEnd
    assert not self.ended
    self.ended = True
    send(self.beneficiary, self.highestBid)