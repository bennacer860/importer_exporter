require 'spec_helper'

describe ImportExport do
  it "should return a formatted json data structure" do
    output_json = JSON.parse(open("./spec/fixtures/output.json").read)
    import_export_json = JSON.parse(ImportExport.export("./spec/fixtures/input.csv","json"))
    expect(import_export_json).to eql(output_json)     
  end

  it 'should raise an error wheen the file does not exist' do
    expect{ImportExport.expect("no.txt")}.to raise_error
  end
end
