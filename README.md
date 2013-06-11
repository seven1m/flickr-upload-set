# Flikr Upload Set

This is a simple Ruby application that lets you browse your computer hard drive for photos that are *not* yet uploaded to your Flickr account.

This application is built as a web app, but it is *not meant to be deployed on a web server*.

![Upload Set](https://raw.github.com/seven1m/flickr-upload-set/master/public/set.png)

## Setup

1. Install ImageMagick. On OS X: `brew install ImageMagick`. On Ubuntu: `sudo apt-get install imagemagick`
2. Install Ruby 1.9.3
3. `gem install bundler`
4. `bundle install`
5. [Create a Flickr APP](http://www.flickr.com/services/apps/create/) and copy the API key and secret. Set the app's callback URL to `http://localhost:4567/auth-complete`
6. [Get your Flickr User ID](http://idgettr.com/)
7. `cp config.rb{.example,} && vim config.rb`
   Paste in the API key and secret from step 5. Paste in your User ID from step 6.

To run the app:

```
ruby app.rb
```

Then load the app in your browser: http://localhost:4567

## TODO

Currently the app only shows you which photos aren't yet on Flickr. In the near future, I hope to add the ability to upload straight from the app to your Flickr account.

## Feedback

If you found a bug, please [create an issue](https://github.com/seven1m/flickr-upload-set/issues). Pull requests are welcome.

[timmorgan.org](http://timmorgan.org) · [github.com/seven1m](http://github.com/seven1m) · [twitter.com/seven1m](http://twitter.com/seven1m) · [coderwall.com/seven1m](https://coderwall.com/seven1m)

## License

Copyright (c) 2013, Tim Morgan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
