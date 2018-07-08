from hello import get_hello

def test_hello_says_hello():
    assert get_hello() == 'hello'
