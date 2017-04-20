class BugsController < ApplicationController
  def index
    search = BugSearch.new(ids: params[:ids], environment_ids: params[:environment_ids], closed: (params[:closed] == "true"), limit: params[:limit])

    render json: search.bugs, include: []
  end

  def show
    bug = fetch_bug
    render json: bug, serializer: FullBugSerializer
  end

  def close
    bug = fetch_bug
    bug.events.create!(name: 'closed')
    render json: fetch_bug, serializer: FullBugSerializer
  end

  def create_issue
    bug = fetch_bug
    CreateBugIssue.perform_later(bug)
    render json: fetch_bug, serializer: FullBugSerializer
  end

  private
  def fetch_bug
    Bug.with_latest_details.find(params[:id])
  end
end
