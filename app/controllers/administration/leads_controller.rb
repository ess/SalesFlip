module Administration
  class LeadsController < AdministrationController

    has_scope :in_campaign, :allow_blank => true do |controller, scope, value|
      value == "All" ? scope.all : scope.in_campaign(value)
    end

    has_scope :assigned_to, :allow_blank => true do |controller, scope, value|
      value == "All" ? scope.all : scope.assigned_to(value)
    end

    has_scope :source_is, :allow_blank => true do |controller, scope, value|
      value == "All" ? scope.all : scope.all(:source => value)
    end

    has_scope :status_is

    def index
      @users = User.all(:order => DataMapper::Query::Direction.new('lower(email)'))

      params[:sort] ||= ["name", "asc"]

      if params[:terms].present?
        @leads = Lead.search do
          keywords params[:terms]
          paginate(:per_page => 100, :page => params[:page])
        end.results
      else
        @leads = Lead::Sorter.new(apply_scopes(Lead))
          .sort_by(*params[:sort])
          .paginate(:per_page => 100, :page => params[:page])
      end
    end

    def assignee
      Lead.all(:id => params[:leads]).update!(:assignee_id => params[:assignee_id])
      redirect_to request.referrer
    end

    def campaign
      Lead.all(:id => params[:leads]).update!(:campaign_id => params[:campaign_id])
      redirect_to request.referrer
    end

    def update_status
      Lead.all(:id => params[:leads]).update!(:status => params[:status])
      redirect_to request.referrer
    end

    def source
      Lead.all(:id => params[:leads]).update!(:source => params[:source])
      redirect_to request.referrer
    end

    def rating
      Lead.all(:id => params[:leads]).update!(:rating => params[:rating])
      redirect_to request.referrer
    end

  end
end
