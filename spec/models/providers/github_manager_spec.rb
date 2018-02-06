require 'rails_helper'

RSpec.describe Providers::GithubManager, type: :model do
  let(:base_manager) { Providers::BaseManager.new('github.com') }
  let(:code) { '2931e223feda1c5c331c'}
  let!(:user) { FactoryBot.create(:user) }
  subject { Providers::GithubManager.new(base_manager.provider) }

  it 'initialize correctly' do
    expect(subject).to be_a_kind_of Providers::GithubManager
    expect(subject.server_type).to eq 'GitHub'
    expect(subject.github_access).to be_a_kind_of Octokit::Client
  end

  it 'exchange_code_for_token!' do
    VCR.use_cassette('sessions/session-new-user-good-code',
                     :decode_compressed_response => true,
                     :record => :none) do
      github_token = subject.exchange_code_for_token!(code)
      expect(github_token).to be_kind_of Sawyer::Resource
      expect(github_token.to_hash).to eq({access_token: '1b91c8b817fac4d3629642ea8f0f48ffbbf9d7fb', token_type: 'bearer', scope: 'user:email'})
      expect(github_token[:token_type]).to eq('bearer')
      expect(github_token[:scope]).to eq('user:email')
      expect(subject.github_access.access_token).to eq('1b91c8b817fac4d3629642ea8f0f48ffbbf9d7fb')
    end
  end

  it 'user' do
    user_obj = {

        login:'user',
        id:3019213,
        avatar_url:'https://avatars2.githubusercontent.com/u/3019213?v=4',
        gravatar_id:'',
        url:'https://api.github.com/users/user',
        html_url:'https://github.com/user',
        followers_url:'https://api.github.com/users/user/followers',
        following_url:'https://api.github.com/users/user/following{/other_user}',
        gists_url:'https://api.github.com/users/user/gists{/gist_id}',
        starred_url:'https://api.github.com/users/user/starred{/owner}{/repo}',
        subscriptions_url:'https://api.github.com/users/user/subscriptions',
        organizations_url:'https://api.github.com/users/user/orgs',
        repos_url:'https://api.github.com/users/user/repos',
        events_url:'https://api.github.com/users/user/events{/privacy}',
        received_events_url:'https://api.github.com/users/user/received_events',
        type:'User',
        site_admin:false,
        name:'User',
        company:'@ManageIQ-Exchange',
        blog:'',
        location:'Madrid,Spain',
        email:'user@exchange.com',
        hireable:true,
        bio:nil,
        public_repos:45,
        public_gists:0,
        followers:24,
        following:10,
        created_at:'2012-12-11T19:52:55Z',
        updated_at:'2018-01-27T15:58:25Z'
    }
    VCR.use_cassette("sessions/session-new-user-good-code",:decode_compressed_response => true, :record => :none) do
        subject.exchange_code_for_token!(code)
        result  = subject.user
        expect(result).to be_kind_of Sawyer::Resource
        expect(result.to_hash).to eq( user_obj )
    end
  end

  it 'readme' do
    VCR.use_cassette("providers/github/get_readme",:decode_compressed_response => true, :record => :none) do
      expect(subject.readme('ManageIQ-Exchange/manageiq-exchange-spin-template')).to eq(
                                                                              "# Test repo for content in ManageIQ Exchange\n\nIn order to publish a Spin in ManageIQ Exchange you will need:\n\n" +
                                                                                  " - A file that identifies the repo as a manageiq-spin\n ```.manageiq-spin```\n - A metadata file with the right" +
                                                                                  " format (please see example in \n ```metadata.yml```\n - At least a release in the GitHub Repo. Please use x.y.z" +
                                                                                  " as the release tag, except for betas or special test releases.\n - A license that is identified in GitHub (use the add license)\n"
                                                                          )
    end
  end

  it 'releases' do
    VCR.use_cassette("providers/github/get_releases",:decode_compressed_response => true, :record => :none) do
      releases = subject.releases('ManageIQ-Exchange/manageiq-exchange-spin-template')
      expect(releases).to be_kind_of Array
      expect(releases).not_to be_empty
    end
  end

  it 'releases fail with @github_access nil' do
    VCR.use_cassette("providers/github/get_releases",:decode_compressed_response => true, :record => :none) do
      subject.instance_variable_set(:@github_access, nil)
      releases = subject.releases('ManageIQ-Exchange/manageiq-exchange-spin-template')
      expect(releases).to be_kind_of ErrorExchange
    end
  end

  it 'repos' do
    VCR.use_cassette("providers/github/get_repos",:decode_compressed_response => true, :record => :none) do
      token = subject.exchange_code_for_token!(code)
      releases = subject.repos(user:user, github_token: token)
      expect(releases).to be_kind_of Array
    end
  end

  it 'right metadata' do
    VCR.use_cassette("providers/github/get_metadata",:decode_compressed_response => true, :record => :none) do
      meta = subject.metadata('ManageIQ-Exchange/manageiq-exchange-spin-template')
      expect(meta).to be_kind_of Array
    end
  end

  it 'metadata not valid schema' do
    VCR.use_cassette("providers/github/get_metadata_schema_fail",:decode_compressed_response => true, :record => :none) do
      @identifier = :spin_error_metadata
      meta = subject.metadata('ManageIQ-Exchange/manageiq-exchange-spin-template')
      expect(meta).to be_kind_of ErrorExchange
      expect_error(meta.as_json)
    end
  end

  it 'metadata is null' do
    VCR.use_cassette("providers/github/get_metadata_nil",:decode_compressed_response => true, :record => :none) do
      @identifier = :spin_metadata_to_json
      meta = subject.metadata('ManageIQ-Exchange/manageiq-exchange-spin-template')
      expect(meta).to be_kind_of ErrorExchange
      expect_error(meta.as_json)
    end
  end
end