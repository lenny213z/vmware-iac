# copyright: 2018, The Authors

title 'Open SSH Port'

# you add controls here
control 'ssh' do
  impact 0.7
  title 'Open SSH Port'
  desc 'Check for SSH Port'
  describe port(22) do
    it { should be_listening }
    its('protocols') {should include 'tcp'}
  end
end
