require 'spec_helper'
require 'overcommit/hook_context/pre_push'

describe Overcommit::HookContext::PrePush do
  let(:config) { double('config') }
  let(:args) { [remote_name, remote_url] }
  let(:input) { double('input') }
  let(:remote_name) { 'origin' }
  let(:remote_url) { 'git@github.com:brigade/overcommit.git' }
  let(:context) { described_class.new(config, args, input) }

  describe '#remote_name' do
    subject { context.remote_name }

    it { should == remote_name }
  end

  describe '#remote_url' do
    subject { context.remote_url }

    it { should == remote_url }
  end

  describe '#pushed_refs' do
    subject(:pushed_refs) { context.pushed_refs }

    let(:local_ref) { 'refs/heads/master' }
    let(:local_sha1) { random_hash }
    let(:remote_ref) { 'refs/heads/master' }
    let(:remote_sha1) { random_hash }

    before do
      input.stub(:read).and_return("#{local_ref} #{local_sha1} #{remote_ref} #{remote_sha1}\n")
    end

    it 'should parse commit info from the input' do
      pushed_refs.length.should == 1
      pushed_refs.each do |pushed_ref|
        pushed_ref.local_ref.should == local_ref
        pushed_ref.local_sha1.should == local_sha1
        pushed_ref.remote_ref.should == remote_ref
        pushed_ref.remote_sha1.should == remote_sha1
      end
    end
  end
end