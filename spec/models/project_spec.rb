require 'rails_helper'

describe Project do
  it 'has default ID 1' do
    expect(Project.new.id).to eq 1
  end

  it 'has default name "Dradis CE"' do
    expect(Project.new.name).to eq 'Dradis CE'
  end

  it 'allows id and name to be set on initialization' do
    project = Project.new(id: 5, name: 'Whatever')
    expect(project.id).to eq 5
    expect(project.name).to eq 'Whatever'
  end

  describe '#issue_library' do
    let(:project) { Project.new }

    it 'creates an ISSUELIB node when none exists' do
      expect(Node.count).to eq(0)
      issuelib = project.issue_library
      expect(Node.count).to eq(1)
      expect(issuelib.type_id).to eq(Node::Types::ISSUELIB)
    end

    it 'returns the ISSUELIB node if one exists' do
      node = project.issue_library
      expect(Node.count).to eq(1)
      expect do
        expect(project.issue_library).to eq node
      end.not_to change { Node.count }
    end
  end
end
