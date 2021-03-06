require 'spec_helper'

describe Crowdblog::ViewsGenerator do
  let(:destination) { 'tmp' }

  before do
    FileUtils.rm_rf 'tmp'
  end

  it "copies all the views" do
    Crowdblog::ViewsGenerator.start([], :destination_root => destination)
    Dir['app/views/**/*'].each do |f|
      File.read(f).should eq File.read(File.join(destination, f)) unless File.directory?(f)
    end
  end
end
