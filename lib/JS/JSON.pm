package JS::JSON;

use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

1;

__END__

=head1 NAME

JS-JSON - JSON module for JS

=head1 SYNOPSIS

    http://www.json.org

=head1 DESCRIPTION

This is a repackaging of L<http://www.json.org/json2.js> for use with the 
L<JS> framework.

=head1 DOCUMENTATION

This file creates a global JSON object containing two methods: stringify
and parse.

=head1 METHODS

=over 4

=item B<JSON.stringify(value, replacer, space)>

=over 4

=item I<value>       

any JavaScript value, usually an object or array.

=item I<replacer>    

an optional parameter that determines how object 
values are stringified for objects. It can be a 
function or an array.

=item I<space>       

an optional parameter that specifies the indentation
of nested structures. If it is omitted, the text will
be packed without extra whitespace. If it is a number,
it will specify the number of spaces to indent at each
level. If it is a string (such as '\t' or '&nbsp;'),
it contains the characters used to indent at each level.

=back

This method produces a JSON text from a JavaScript value.

When an object value is found, if the object contains a toJSON
method, its toJSON method will be called and the result will be
stringified. A toJSON method does not serialize: it returns the
value represented by the name/value pair that should be serialized,
or undefined if nothing should be serialized. The toJSON method
will be passed the key associated with the value, and this will be
bound to the object holding the key.

For example, this would serialize Dates as ISO strings.

  Date.prototype.toJSON = function (key) {
      function f(n) {
          // Format integers to have at least two digits.
          return n < 10 ? '0' + n : n;
      }
  
      return this.getUTCFullYear()   + '-' +
           f(this.getUTCMonth() + 1) + '-' +
           f(this.getUTCDate())      + 'T' +
           f(this.getUTCHours())     + ':' +
           f(this.getUTCMinutes())   + ':' +
           f(this.getUTCSeconds())   + 'Z';
  };

You can provide an optional replacer method. It will be passed the
key and value of each member, with this bound to the containing
object. The value that is returned from your method will be
serialized. If your method returns undefined, then the member will
be excluded from the serialization.

If the replacer parameter is an array, then it will be used to
select the members to be serialized. It filters the results such
that only members with keys listed in the replacer array are
stringified.

Values that do not have JSON representations, such as undefined or
functions, will not be serialized. Such values in objects will be
dropped; in arrays they will be replaced with null. You can use
a replacer function to replace those with JSON values.
JSON.stringify(undefined) returns undefined.

The optional space parameter produces a stringification of the
value that is filled with line breaks and indentation to make it
easier to read.

If the space parameter is a non-empty string, then that string will
be used for indentation. If the space parameter is a number, then
the indentation will be that many spaces.

Example:

  text = JSON.stringify(['e', {pluribus: 'unum'}]);
  // text is '["e",{"pluribus":"unum"}]'
  
  
  text = JSON.stringify(['e', {pluribus: 'unum'}], null, '\t');
  // text is '[\n\t"e",\n\t{\n\t\t"pluribus": "unum"\n\t}\n]'
  
  text = JSON.stringify([new Date()], function (key, value) {
      return this[key] instanceof Date ?
          'Date(' + this[key] + ')' : value;
  });
  // text is '["Date(---current time---)"]'


=item B<JSON.parse(text, reviver)>

This method parses a JSON text to produce an object or array.
It can throw a SyntaxError exception.

The optional reviver parameter is a function that can filter and
transform the results. It receives each of the keys and values,
and its return value is used instead of the original value.
If it returns what it received, then the structure is not modified.
If it returns undefined then the member is deleted.

Example:

    // Parse the text. Values that look like ISO date strings will
    // be converted to Date objects.

    myData = JSON.parse(text, function (key, value) {
        var a;
        if (typeof value === 'string') {
            a = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2}(?:\.\d*)?)Z$/.exec(value);
            if (a) {
                return new Date(Date.UTC(+a[1], +a[2] - 1, +a[3], +a[4],
                    +a[5], +a[6]));
            }
        }
        return value;
    });

    myData = JSON.parse('["Date(09/09/2001)"]', function (key, value) {
        var d;
        if (typeof value === 'string' &&
                value.slice(0, 5) === 'Date(' &&
                value.slice(-1) === ')') {
            d = new Date(value.slice(5, -1));
            if (d) {
                return d;
            }
        }
        return value;
    });


This is a reference implementation. You are free to copy, modify, or
redistribute.

=head1 AUTHOR

Stevan Little is the packager of JS-JSON

This Javascript is Public Domain, as is this repackaging of it.

NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.

=cut