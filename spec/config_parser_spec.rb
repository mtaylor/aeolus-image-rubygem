#   Copyright 2011 Red Hat, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

require 'spec_helper'

module Aeolus
  module Image
    describe ConfigParser do
      it "should parse the specified command" do
        config_parser = ConfigParser.new(%w(list  --images))
        config_parser.process
        config_parser.command.should == 'list'
      end

      it "should exit gracefully when a required subcommand is not provided" do
        begin
          silence_stream(STDOUT) do
            config_parser = ConfigParser.new(%w(list))
            config_parser.process
            config_parser.should_receive(:exit).with(1)
          end
        rescue SystemExit => e
          e.status.should == 1
        end
      end

      it "should notify the user of an invalid command" do
        config_parser = ConfigParser.new(%w(sparkle))
        config_parser.should_receive(:exit).with(0)
        silence_stream(STDOUT) do
          config_parser.process
        end
      end

      it "should exit gracefully with bad params" do
        begin
          silence_stream(STDOUT) do
            ConfigParser.new(%w(delete --fred)).should_receive(:exit).with(1)
          end
        rescue SystemExit => e
          e.status.should == 1
        end
      end

      it "should set options hash for valid general options" do
        config_parser = ConfigParser.new(%w(list --user joe --password cloud --images))
        config_parser.options[:user].should == 'joe'
        config_parser.options[:password].should == 'cloud'
        config_parser.options[:subcommand].should == :images
      end

      it "should set options hash for valid list options" do
        config_parser = ConfigParser.new(%w(list --builds 12345))
        config_parser.options[:subcommand].should == :builds
        config_parser.options[:id].should == '12345'
      end

      it "should set options hash for valid build options" do
        config_parser = ConfigParser.new(%w(build --target ec2,rackspace --image 12345 --template my.tmpl))
        config_parser.options[:target].should == ['ec2','rackspace']
        config_parser.options[:image].should == '12345'
        config_parser.options[:template].should == 'my.tmpl'
      end

      it "should set options hash for valid push options" do
        config_parser = ConfigParser.new(%w(push --provider ec2-us-east1 --id 12345))
        config_parser.options[:provider].should == ['ec2-us-east1']
        config_parser.options[:id].should == '12345'
      end

      it "should set options hash for valid delete options" do
        config_parser = ConfigParser.new(%w(delete --build 12345))
        config_parser.options[:build].should == '12345'
      end

      it "should set options hash for valid import options" do
        config_parser = ConfigParser.new(%w(import --provider ec2-us-east-1a --description /path/to/file --id ami-123456 --target ec2))
        config_parser.options[:provider].should == ['ec2-us-east-1a']
        config_parser.options[:target].should == ['ec2']
        config_parser.options[:description].should == '/path/to/file'
        config_parser.options[:id].should == 'ami-123456'
      end
    end
  end
end
