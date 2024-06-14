---
title: Two missing features from HTML5, an enhanced form.enctype and a list input type
author: R. S. Doiel
keywords: [ "html", "web forms", "encoding" ]
---

# Two missing features from HTML5, an enhanced form.enctype and a list input type

## Robert's wish list for browsers and web forms handling

By R. S. Doiel, 2024-02-23

I wish the form element supported a `application/json` encoding type and there was such a thing as a `list-input` element.

I've been thinking about how we can get back to basic HTML documents and move away from JavaScript required to render richer web forms. When web forms arrived on scene in the early 1990s they included a few basic input types. Over the years a few have been added but by and large the data model has remained relatively flat. The exception being the select element with `multiple` attribute set. I believe we are being limited by the original choice of urlencoding web forms and then resort to JavaScript to address it's limitations.

What does the encoding of a web form actually look like?  The web generally encodes the form using urlencoding. It presents a stream of key value pairs where the keys are the form's input names and the values are the value of the input element. With a multi-select element the browser simply repeats the key and adds the next value in the selection list to that key.  In Go you can describe this simple data structure as a `map[string][]string`[^1]. Most of the time a key points to a single element array of string but sometimes it can have multiple elements using that key and then the array expands to accommodate. Most of the time we don't think about this as web developers. The library provided with your programming language decodes the form into a more programmer friendly representation. But still I believe this simple urlencoding has held us back. Let me illustrate the problem through a series of simple form examples.

[^1]: In English this could be described as "a map using a string to point at a list of strings" with "string" being a sequence of letters or characters.

Here's an example of a simple form with a multi select box. It is asking for your choice of ice cream flavors.

~~~html
<form method="POST">
  <label for="ice-cream-flavors">Choose your ice cream flavors:</label>
  <select id="ice-cream-flavors" name="ice-cream-flavors" multiple >
    <option value="Chocolate">Chocolate</option>
    <option value="Coconut">Cocunut</option>
    <option value="Mint">Mint</option>
    <option value="Strawberry">Strawberry</option>
    <option value="Vanilla">Vanilla</option>
    <option value="Banana">Banana</option>
    <option value="Peanut">Peanut</option>
  </select>
  <p>
  <input type="submit"> <input type="reset">
</form>
~~~

By default your web browser will packaged this up and send it using "application/x-www-form-urlencoded". If you select "Coconut" and "Strawberry" then the service receiving your data will get an encoded document that looks like this.

~~~urlencoding
ice-cream-flavors=Coconut&ice-cream-flavors=Strawberry
~~~

The ampersands separate the key value pairs. The fact that "ice-cream-flavors" name repeats means that the key "ice-cream-flavors" will point to an array of values.  In pretty printed JSON representation is a little clearer.

~~~json
{
    "ice-cream-flavors": [ "Coconut", "Strawberry" ]
}
~~~

So far so good. Zero need to enhance the spec. It works and has worked for a very long time. Stability is a good thing. Let's elaborate a little further.  I've added a dish choice for the ice cream, "Sugar Cone" and "Waffle Bowl". That web form looks like.

~~~html
<form method="POST">
<label for="ice-cream-flavors">Select the flavor for each scoop of ice cream:</label>
<select id="ice-cream-flavors" name="ice-cream-flavors" multiple>
  <option value="Chocolate">Chocolate</option>
  <option value="Coconut">Cocunut</option>
  <option value="Mint">Mint</option>
  <option value="Strawberry">Strawberry</option>
  <option value="Vanilla">Vanilla</option>
  <option value="Banana">Banana</option>
  <option value="Peanut">Peanut</option>
</select>
<p>
<fieldset>
  <legend>Pick your delivery dish</legend>
  <div>
    <input type="radio" id="sugar-cone" name="ice-cream-dish" value="sugar-cone" />
    <label for="sugar-cone">Sugar Cone</label>
  </div>
  <div>
    <input type="radio" id="waffle-bowl" name="ice-cream-dish" value="waffle-bowl" />
    <label for="waffle-bowl">Waffle Bowl</label>
  </div>
</fieldset>
<input type="submit"> <input type="reset">
</form>
~~~

If we select "Banana" and "Peanut" flavors served in a "Waffle Bowl" the encoded document would reach the web service looking something like this.

~~~urlencoded
ice-cream-flavors=Banana&ice-cream-flavors=Peanut&ice-cream-dish=waffle-cone
~~~

That's not too bad. Again this is the state of web form for ages now. In JSON it could be represented as the following.

~~~json
{
    "ice-cream-flavors": [ "Banana", "Peanut" ],
    "ice-cream-dish": "waffle-cone"
}
~~~

This is great we have a simple web form that can collect a single ice cream order.  But what if we want to actually place several individual ice cream orders as one order? Today we have two choices, multiple web forms that accumulate the orders (circa 2000) or use JavaScript create a web UI that can handle list of form elements. Both have their drawbacks.

In the case of the old school approach changing web pages just to update an order can be slow and increase uncertainty about your current order. That is why the JavaScript approach has come to be more common. But that JavaScript approach comes at a huge price. It's much more complex, we've seen a dozens of libraries and frameworks that have come and gone trying to manage that complexity in various ways.

If we supported JSON encoded from submission directly in the web browser I think we'd make a huge step forward. It could decouple the JavaScript requirement. That would avoid much of the cruft that we ship down to the web browser today because we can't manage lists of things without resorting to JavaScript.

Let's pretend there was a new input element type called "list-input". A "list-input" element can contain any combination of today's basic form elements. Here's my hypothetical `list-input` based from example. In it we're going to select the ice cream flavors and the dish format (cone, bowl) as before but have them accumulate in a list. That form could be expressed in HTML similar to my mock up below.

~~~html
<form>
  <label for="ice-cream-order">Place your next order, press submit when you have all of them.</label>
  <list-input id="ice-cream-order" name="ice-cream-order">
    <label for="ice-cream-flavor">Select the flavor for each scoop of ice cream:</label>
    <select id="ice-cream-flavor" name="ice-cream-flavor" multiple>
      <option value="Chocolate">Chocolate</option>
      <option value="Coconut">Cocunut</option>
      <option value="Mint">Mint</option>
      <option value="Strawberry">Strawberry</option>
      <option value="Vanilla">Vanilla</option>
      <option value="Banana">Banana</option>
      <option value="Peanut">Peanut</option>
    </select>
  <p>
  <fieldset>
    <legend>Pick your delivery dish</legend>
    <div>
      <input type="radio" id="sugar-cone" name="ice-cream-dish" value="sugar-cone" />
      <label for="sugar-cone">Sugar Cone</label>
    </div>
    <div>
      <input type="radio" id="waffle-bowl" name="ice-cream-dish" value="waffle-bowl" />
      <label for="waffle-bowl">Waffle Bowl</label>
    </div>
  </fieldset>
  </list-input>
  <input type="submit"> <input type="reset">
</form>
~~~

With two additional lines of HTML the input form can now support a list of individual ice cream orders. Assuming only urlencoding is supported then how does that get encoded and sent to the web server? Here is an example set of orders

1. vanilla ice cream with a sugar cone
2. chocolate with a waffle bowl

~~~urlencoded
ice-cream-flavors=Vanilla&ice-cream-flavors=Chocolate&ice-cream-dish=sugar-cone&ice-cream-dish=waffle-bowl
~~~

Which flavor goes with which dish?  That's the problem with urlencoding a list in your web form. We just can't keep the data alignment manageable.  What if the web browser used JSON encoding? 

~~~json
[
  {
      "ice-cream-flavors": [ "Vanilla" ],
      "ice-cream-dish": "sugar-cone"
  },
  {
      "ice-cream-flavors": [ "Chocolate" ],
      "ice-cream-dish": "waffle-bowl"
  }
~~~

Suddenly the alignment problem goes away. There is precedence for controlling behavior of the web browser submission through the `enctype` attribute. File upload was addressed by adding support for `multipart/form-data`.  In 2024 and for over the last decade it has been common practice in web services to support JSON data submission. I believe it is time that the web browser also supports this directly. This would allow us to decouple the necessity of using JavaScript in browser as we require today. The form elements already map well to a JSON encoding. If JSON encoding was enabled then adding a element like my "list-input" would make sense.  Otherwise we remain stuck in a world where hypertext markup language remains very limited and can't live without JavaScript.

