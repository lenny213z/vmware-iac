# copyright: 2018, The Authors

title 'Open Web Ports'

# you add controls here
control 'http or https' do
  impact 0.7
  title 'Open Web Ports'
  desc 'Check for Open Web Ports'
  describe.one do
    describe port(80) do
      it { should be_listening }
      its('protocols') {should include 'tcp'}
    end
    describe port(443) do
      it { should be_listening }
      its('protocols') {should include 'tcp'}
    end
  end
end
