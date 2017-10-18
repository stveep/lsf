require 'spec_helper'
require 'lsf'

describe Lsf do
  before(:each) do
    ENV['LSF_PROJECT'] = "PROJECTCODE"
  end

  it 'has a version number' do
    expect(Lsf::VERSION).not_to be nil
  end

  it 'submits a job with default options' do
    job = Lsf.new 
    expect(job).to receive(:system).with(/ls/)
    job.submit_job "ls"
  end

  it 'submits a job with custom options' do
    job = Lsf.new 
    expect {job.submit_job "ls", "o" => "custom"}.to output(/custom/).to_stdout
    expect {job.submit_job "ls", "o" => "custom"}.to_not output(/lsf_output/).to_stdout
  end
end
