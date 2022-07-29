# iOS ReplayKit Extension Frame Sharing
iOS app to receive CMSampleBuffers from ScreenShare Broadcast extension to UI and ability to pass messages from Broadcast Extension to the host app and vice versa.

We all know that iOS apps are sandboxed which means data cant be shared between 2 apps/targets directly. If we need to implement a screen sharing logic on a pre existing app it can be hard to get the screen frames to the app from broadcast extension as it runs on its own sandboxed environment. 

## Features
1. Ability to pass CMSampleBuffers from SampleHandler.swift to the host app. 
> This is achieved using local sockets. We basically create a server and a client and open an available socket at 127.0.0.x.
> The host app creates a server whereas the broadcast extension creates a client. 
> The socket is written in objective C and can be used as it is. This repository uses objective C socket with a swift SampleHandler.swift and a ViewController.swift using bridging headers. 

2. Ability to pass messages from Host app to the extension and vice versa.
> This is achieved using CFNotificationCenter. These notifications differ from NSNotificationCentre as these can be ised to broadcast system-wide notifications that can be used to communicate between different targets or apps. 

3. Ability to stop Screen Share broadcast extension programatically.

4. Ability to open Broadcast picker view programatically. 
