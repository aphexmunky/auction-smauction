import pytest

@pytest.fixture
def auction_contract(auction, accounts):
    print(accounts[0])
    yield auction.deploy(accounts[0], 3 * 24 * 60 * 60, {'from': accounts[0]})

def test_initial_state(auction_contract, accounts):
    assert auction_contract.auctionStart() > 0
    assert auction_contract.auctionEnd() > auction_contract.auctionStart()
    assert auction_contract.beneficiary() == accounts[0]
    assert auction_contract.highestBid() == 0

def test_bid(auction_contract, accounts):
    auction_contract.bid({'from': accounts[0], 'value': 1})
    assert auction_contract.highestBid() == 1
    assert auction_contract.highestBidder() == accounts[0]
    auction_contract.bid({'from': accounts[1], 'value': 20})
    assert auction_contract.highestBid() == 20
    assert auction_contract.highestBidder() == accounts[1]