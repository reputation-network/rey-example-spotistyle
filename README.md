Spotistyle App
==============

Example REY app that lets music fans share in the Reputation Network the music genres they listen to the most.

Available live at http://rey-example-spotistyle.herokuapp.com.

Requirements
------------

You'll need [rey-cli](http://github.com/reputation-network/rey-cli) installed in your system.

Configuration
-------------

You'll need to set up the environment variables `SPOTIFY_CLIENT_ID` and `SPOTIFY_CLIENT_SECRET` with a valid [Spotify app]<https://developer.spotify.com>. The easiest way is using a `.env` file.

Usage
-----

Simply start the app with:

    docker-compose up

Then, you'll need to register the app's manifest on the running blockchain node with:

    rey-cli dev cmd publish-manifest 0x88032398beab20017e61064af3c7c8bd38f4c968 http://localhost:8000/manifest

You'll need to publish the verifier's manifest:

    rey-cli dev cmd publish-manifest 0x44f1d336e4fdf189d2dadd963763883582c45312 http://localhost:8082/manifest

You can visit the app at `http://localhost:8000`.

To read the REY app, add your Metamask private key to the blockchain node:

    rey-cli dev cmd add-account <YOUR_METAMASK_PRIVATE_KEY>

Then run:

    rey-cli dev cmd read-app 0x88032398beab20017e61064af3c7c8bd38f4c968 <YOUR_ADDRESS> 0x44f1d336e4fdf189d2dadd963763883582c45312
