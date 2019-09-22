class LeavesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_leave, only: [:show, :edit, :update, :destroy]
  before_action :max_leaves, only: [:new]
  def index
    @leaves = Leave.where(user_id: current_user.id)
    @applied_leaves = Leave.where(status: "applied").where(user_id: current_user.id)
    @approved_leaves = Leave.where(status: "approved").where(user_id: current_user.id)
    @rejected_leaves = Leave.where(status: "rejected").where(user_id: current_user.id)
    @leave_balance = current_user.max_leave - Leave.where(status: "rejected").where(user_id: current_user.id).count

    current_user.max_leave
  end

  def show
  end

  def new
    @leaves = Leave.where(user_id: current_user.id)
    @leave = Leave.new
  end

  def edit
  end

  def create
    @leave = Leave.new(leave_params)
    to_date = params[:leave][:leave_to]
    from_date = params[:leave][:leave_from]
    @leave.leave_to  = Date.strptime(to_date, '%m/%d/%Y')
    @leave.leave_from = Date.strptime(from_date, '%m/%d/%Y')
    @leave.leave_apply = DateTime.now
    @leave.status = "applied"
    @leave.user_id = current_user.id
    respond_to do |format|
      if @leave.save
        if Rails.env.development?
         UserMailer.leave_request_email(current_user, @leave).deliver_now
        end
        format.html { redirect_to leaves_path, notice: 'leave was successfully created.' }
        format.json { render :new, status: :created, location: @leave }
      else
        flash[:alert] =  @leave.errors.full_messages.to_sentence
        format.html { render :new}
        format.json { render json: @leave.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    to_date = params[:leave][:leave_to]
    from_date = params[:leave][:leave_from]
    to_date  = Date.strptime(to_date, '%m/%d/%Y')
    from_date = Date.strptime(from_date, '%m/%d/%Y')
    reason = params[:leave][:reason]
    respond_to do |format|
      if @leave.update(leave_to: to_date, leave_from: from_date, leave_apply: DateTime.now, reason: reason )
        if Rails.env.development?
          UserMailer.leave_request_email_edited(current_user, @leave).deliver_now
        end
        format.html { redirect_to leaves_path, notice: 'leave was successfully updated.' }
        format.json { render :show, status: :ok, location: @leave }
      else
        flash[:alert] =  @leave.errors.full_messages.to_sentence
        format.html { render :edit }
        format.json { render json: @leave.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @leave.destroy
    respond_to do |format|
      format.html { redirect_to admin_leave_path, notice: 'leave was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leave
      @leave = Leave.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leave_params
      params.fetch(:leave, {})
      params.require(:leave).permit(:leave_apply,:leave_to,:leave_from,:reason,:reporting_head)
    end

  def max_leaves
    if current_user.max_leave == (current_user.leaves.where(:status => "approved").count + current_user.leaves.where(:status => "applied").count)
      flash[:notice] = "Sorry , Your Leaves Have been Completed"
      redirect_to leaves_path
    end  
  end  

end