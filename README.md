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
