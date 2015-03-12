## DESIGN:

In Order to implement a class what will import files in a certain format and export in another format we need to have fairly easy format in the middle that we can translate later easily to other format. The best option here is to format to a Ruby Object first and then export to the format requested.

csv  -> ruby object -> json
json -> ruby object -> yaml

This way allows us more modularity and flexibility. This design would require from us to implment import functions `from_formatname` and export functions `to_formatname`.

In our case, we are getting `to_json` for free , so we had to implement `from_csv`. However, if we decide to export in another format let's say `txt` we would need to implement a `to_txt` and add it to the control `when`, the same goes for a new import format. Some example have been add and commented out.

## TEST:

Testing the main feature of these code seems to be hard. Some validation libraries need to make sure that the exported/imported code has the correct format.
I am relying on the native libraries to throw an error if the format is malformed. In our case the `csv` library.

However we can still try to see if given the same input the ImportExport will export the same json code. We are going to parse both result to ruby object and see if they are the same.
I have picked only two line of the csv file as the input. I have formated the expected json response to a valid json data structure. Now i can run my rspec test very easily to tell me if my code is generated the expected result.

