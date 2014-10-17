# Hash Array Mapped Tries

Today I investigated hamster, a ruby gem that provides immutable data structures.  Specifically, I looked at how Hamster::Hash was implemented.  It uses a trie, more specifically an array mapped trie, thus the hash implementation is commonly known as an HAMT (hash array mapped trie)

Hamster’s trie uses 5-bit dispatching.  The key is hashed via ruby’s `Object#hash` function.  The absolute value of that value is taken, and then bitshifted right by 5 * the current depth.  This value is bitwise AND'ed with 11111 to grab a value between 0 and 31, since we use 5-bit dispatching.

```
def index_for(key)
  (key.hash.abs >> @significant_bits) & 31
end
```
The Trie basically consists of an array of 32 data entries and an array of 32 children.  To put a (key,value) pair in the Trie, we first find the index of the key.  If no entry exists for that index in the Trie, we set the (key,value) pair there.  If one does and the key of that existing entry does not equal the key we're trying to set, then we find the child at that index.  If no child exists, then we create a new Trie, set it at that index in our array of children, mark the depth (+5 bits per additional depth) of the Trie and put the (key,value) pair on that child.  If a child already exists, we grab the child and put the (key,value) pair on that child.

