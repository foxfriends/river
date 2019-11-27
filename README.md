[VIPER]: https://www.objc.io/issues/13-architecture/viper/
[Flux]: https://github.com/facebook/flux
[RIBs]: https://github.com/uber/RIBs

# The River Architecture for Application Development

The __River__ architecture structures your application to have data flow in a single direction,
from the *Source* to the *Destination*. It builds on the ideas of:
*   single responsibility principle, inspired by [VIPER][];
*   unidirectional data flow, inspired by [Flux][]; and
*   modular components, inspired by [RIBs][].

This architecture is designed with the following goals in mind:
1.  Reactivity: Data should flow through your app, and react to changes automatically, so as to
    reduce the code required to update the UI, and reduce the opportunities for values to be out
    of sync.
2.  Type safety: You should be able to statically define these components such that they can
    only be combined correctly. Of course, actually doing this depends on your programming language.
3.  Reusability: Components performing similar tasks should be able to reuse all shared code
    easily. There must be as little desire to resort to copy paste as possible, because you'll do it
    if it's easier, even though you know it's wrong.
4.  Modularity: Components performing different tasks should be easy to modify without affecting any
    other components, yet they should be easy to combine into powerful interfaces.

## Components

This diagram shows generally how information might flow within your app:

```
Connectors:  Distribution   ]           [      Inflation     ]          [      Emission      ]           [      Distribution
Phases:              [       Acquisition         ]  [        Presentation       ]  [            Reaction             ]
Components:        -> Source -> Relay -> Provider -> Receiver -> View -> Emitter -> Responder -> Agent -> Destination ->
                                  ↑                               ↑                                ↑
                                   \------------------------- Coordinator ------------------------/
```

Though it would appear there are a lot of components to keep in mind here, each is very simple,
and handles exactly one task. Keeping track of where your code lives will be pretty easy!
They can be broken down into three phases, which look very similar:
1.  The __Acquisition__ phase, consisting of the Source, Relay, and Provider, which handles the
    acquisition of data.
2.  The __Presentation__ phase, consisting of the Receiver, View, and Emitter, which handles the
    presentation of data on the screen, and provides ways for the user to interact with that data.
3.  The __Reaction__ phase, consisting of the Responder, Agent, and Destination, which handles
    reacting to the actions from the user.

Each phases consists of three components:
1.  The __Input__ component (Source, Receiver, Responder), which takes information from outside to be
    processed internally.
2.  The __Work__ component (Relay, View, Agent), which process the data it received from the Input and
    sends it to the Output.
2.  The __Output__ component (Provider, Emitter, Desination), where information which has been processed
    is sent.

The three phases are connected (Output to Input) to form a sort of cycle by the three connectors:
1.  The __Inflation__ connector, which transfers data from the Acquisition phase (Relay) to the
    Presentation phase
2.  The __Emission__ connector, which transfers events from the Presentation phase (View) to the
    Response phase (Agent)
3.  The __Distribution__ connector, which transfers data in to the app from external sources, and
    sends events to other external sources to cause changes.

The last piece is the Coordinator, which handles the work of coordinating the three phases,
attaching the connectors, and navigating between scenes of the app.

The name *River* is supposed to capture the idea of data finding its own way along a simple path
from the Source to the Destination, but can also be conveniently found in the names of these
components, in the order they occur: **R**elay **I**nflation **V**iew **E**mission **R**eaction.
This is purely coincidence, but might help you remember something if you really need to.

### Source

The __Source__ refers to the source of your data. Often this will be your server, or a database on the
device. The goal of the Source is to abstract away the retrieval and storage of data. This way, the rest
of the app can focus on the data that was received and does not need to be concerned with low level
behaviours, like
*   API calls,
*   Caching, or
*   Pagination.

The actual implementation of the Source is very much up to you. In fact, you will likely want to have
multiple Sources which are combined later. Some examples are:
*   A remote API
*   An on-device database or cache
*   Push notifications
*   In-app changes (`NotificationCenter`)

### Relay

A __Relay__ wraps the Source (or combines a number of Sources) to provide a handle to the underlying
resource. The goals of the Relay are to provide
a)  reactivity, and
b)  a way to view only the data that is needed.

Though it will be used similarly to a model might be in another architecture, the Relay is better
considered a way to *view* the Source data, and *not* the data itself. Since the Relay is just viewing
the data (as opposed to being a copy of the data), when the underlying data changes, the Relay should
update as well. This is how we get reactivity in the rest of the app.

As for only retrieving the data that is needed, consider a list of animals at a zoo. At first, you
may be presented with a page that lists the most popular animals of each species in separate sections,
each with a "View All" button. Then you press "View All" and go to a page which lists *all* animals of
one species. These two screens would require a different view of the data, and so would have different
Relays.

### Provider

A __Provider__ is a protocol, typically implemented by a Relay, which defines the actual data which
must be made available by that Relay. This protocol will look somewhat similar to how a traditional
model would look: mostly just accessors for data. Once you have each Relay handling exactly its one
task, to actually make use of those Relays in a reusable manner, they each conform to the same set
of Providers.

In the example above, we have two Relays which both provide a list of animals, so they would likely
both be able to satisfy the same Provider.

### Receiver

A __Receiver__ is a protocol which defines a set of outlets for data to be bound to. Typically, the
Providers and Receivers mirror each other, and are plugged together to get the data flowing.

The two screens (all species and one species) would likely have some different details, but both
share a list of animals, so these two screens could share some of the same Receivers.

### View

The __View__ is pretty much unchanged from its usual meaning. It is a very thin wrapper around
what actually appears on screen. In the case of an iOS app, this might be the contents of a
NIB/Storyboard file, while for a web-app this may be an HTML template. They are configured with
data, where applicable, by implementing Receivers.

The term View here encompasses the idea of View and Controller as one concept. How you implement
this is up to you. Feel free to use a View Controller and View Model if you are more comfortable
with that, or just use a single View Controller. Consider that much of the actual work that would
usually end up here has been extracted already to the other components, so a single View Controller may
likely be manageable in most cases. All it really needs to do is link the Receiver to the actual
UI elements, and then link the UI elements to the Emitter. The View should *not* be doing any serious
processing or business logic beyond what validation it may need to perform internally.

### Emitter

An __Emitter__ is a protocol which defines a set of events which a View may produce. This works similarly
to a Provider, but instead of for data from the Relay, it is for events from a View.

### Responder

A __Responder__ is a protocol providing a way to respond to events from the Emitter. This works similarly
to a Receiver, but is receiving events from the Emitter, instead of data changes from the Relay.

### Agent

The __Agent__ acts on behalf of the user of the app by handling events corresponding to user input. Where
the Relay acts as a way to view the data, the Agent acts similarly, as a view of the outside world and
the actions that can be performed there. The Agent does not perform the action, rather it transmits the
action to somewhere where it can be handled.

### Destination

The __Destination__ is the component which is actually responsible for handling actions. This could be any
number of things, similar to the Source. Some common ones might be
*   an API,
*   the `NotificationCenter` for in-app communication, or
*   the Coordinator for navigation events.

### Coordinator

The __Coordinator__ is the last component, which is basically just links up all the other components,
and provides ways to navigate between different views. A Coordinator encapsulates one task of your
app, coordinating the various moving pieces of that task. By adding, removing, and transitioning between
active coordinators, you transition between the various states of your app.
