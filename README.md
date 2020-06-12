# MiniGraph

[![Build Status](https://travis-ci.org/coroutine/mini_graph.svg?branch=master)](https://travis-ci.org/coroutine/mini_graph)

Hi!  MiniGraph is a Ruby gem who's name says it all: it is mini--in functionality
and user experience--and it's a graph implementation.  Imagine that!

MiniGraph provides a small DSL for defining and searching graphs.  Behind the scenes,
MiniGraph uses a core set of classes to support the DSL.  Of course, you are free
to directly use these classes for defining and searching graphs, if that better
suits your taste.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mini_graph'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mini_graph

## Usage

Honestly, there's not a lot to cover here, so we'll keep it brief.

First, let's have a look at the DSL.  The DSL covers two concerns:

1. Defining graphs: these can be directed or undirected
2. Searching graphs: we provide depth-first and breadth-first search functionality, feel free to extend this.

Now, let's take a closer look at the graph definition DSL.

### DSL: Defining graphs

By default, all graphs created using the graph DSL are undirected.  Here's an
example of a new, undirected graph as created with the DSL:

```ruby
jim   = { name: 'Jim',  likes: %w(bears quilts buttermilk) }
john  = { name: 'John', likes: %w(tires mailboxes wombats marshmallows) }
jill  = { name: 'Jill', likes: %w(wind wrappers socks clay) }
jane  = { name: 'Jane', likes: %w(cds parachutes corndogs living) }

# Create a new undirected graph, with the 4 vertices: jim, john, jill, jane.
friends = MiniGraph.create(jim, john, jill, jane) do

  # create edges from jim, to john, jill and jane.
  edge from: jim,   to: [john, jill, jane]

  # create edges from john, to jill and jane
  edge from: john,  to: [jill, jane]

  # create an edge from jane to jill
  edge from: jane,  to: jill
end
```

In the previous example, we create our graph to contain a know set of vertices.  
Vertices can only be added to a graph during creation.  At no other point in the
lifecycle of the graph may vertices be added or deleted.

Also notice the ability to define edges from a vertex to one or more vertices.
This is one of the nice little shortcuts provided by the DSL.  But wait, there's more!
We can also easily define edges from many vertices to many vertices.  Take, for
example, this complete, undirected graph:

```ruby
poker_friends = MiniGraph.create(jim, john, jill, jane) do
  edge from: [jim, john, jill, jane], to: [jim, john, jill, jane]
end
```

Dang! That was easy!  Ok, enough feigning astonishment!

We've now seen undirected graphs, as defined using the MiniGraph DSL, let's
now take a look at directed graphs.  Let's use our first example, but this time
we'll make the edges directed.  Here we go!

```ruby
# Create a new undirected graph, with the 4 vertices: jim, john, jill, jane.
friends = MiniGraph.create(jim, john, jill, jane) do

  # Make this a directed graph.
  directed!

  # create edges from jim, to john, jill and jane.
  edge from: jim,   to: [john, jill, jane]

  # create edges from john, to jill and jane
  edge from: john,  to: [jill, jane]

  # create an edge from jane to jill
  edge from: jane,  to: jill
end
```

Did you see that?!  We just added `directed!`, and that was it!  Smooth and declarative.

Did I hear you say you wanted the same declarative syntax for undirected graphs? Boom!
Just use the `undirected!` declaration, and you're set!

Now, let's move on to searching.

### DSL: Searching graphs

Now that we know how to define graphs, we should probably be able to find stuff
in them, right?

The MiniGraph search DSL is pretty minimal.  You wanna do a depth-first search?
Check it:

```ruby
# Searching our previously defined friends graph, and starting our search at the 'john' vertex:
results = MiniGraph.dfs friends, start_at: john

# results implements Enumerable
results.entries # => [john, jim, jill, jane]
```

...and here's breadth-first search on the same graph:

```ruby
results = MiniGraph.bfs friends, start_at: jill
results.entries # => [jill, jim, john, jane]
```

That's it for the DSL!  Not much to it, right?  You might even call it _Mini_.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/coroutine/mini_graph.
