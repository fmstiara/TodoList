class SubTasksController < ApplicationController
  before_action :set_sub_task, only: [:show, :edit, :update, :destroy]

  # GET /sub_tasks
  # GET /sub_tasks.json
  def index
    @sub_tasks = SubTask.all
  end

  # GET /sub_tasks/1
  # GET /sub_tasks/1.json
  def show
  end

  # GET /sub_tasks/new
  def new
    @sub_task = SubTask.new
  end

  # GET /sub_tasks/1/edit
  def edit
  end

  # POST /sub_tasks
  # POST /sub_tasks.json
  def create
    @sub_task = SubTask.new(sub_task_params)

    respond_to do |format|
      if @sub_task.save
        format.html { redirect_to @sub_task, notice: 'Sub task was successfully created.' }
        format.json { render :show, status: :created, location: @sub_task }
      else
        format.html { render :new }
        format.json { render json: @sub_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_tasks/1
  # PATCH/PUT /sub_tasks/1.json
  def update
    respond_to do |format|
      if @sub_task.update(sub_task_params)
        format.html { redirect_to @sub_task, notice: 'Sub task was successfully updated.' }
        format.json { render :show, status: :ok, location: @sub_task }
      else
        format.html { render :edit }
        format.json { render json: @sub_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_tasks/1
  # DELETE /sub_tasks/1.json
  def destroy
    @sub_task.destroy
    respond_to do |format|
      format.html { redirect_to sub_tasks_url, notice: 'Sub task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_task
      @sub_task = SubTask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_task_params
      params.require(:sub_task).permit(:content, :task_id)
    end
end
