require 'test_helper'

class SubTasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_task = sub_tasks(:one)
  end

  test "should get index" do
    get sub_tasks_url
    assert_response :success
  end

  test "should get new" do
    get new_sub_task_url
    assert_response :success
  end

  test "should create sub_task" do
    assert_difference('SubTask.count') do
      post sub_tasks_url, params: { sub_task: { content: @sub_task.content, task_id: @sub_task.task_id } }
    end

    assert_redirected_to sub_task_url(SubTask.last)
  end

  test "should show sub_task" do
    get sub_task_url(@sub_task)
    assert_response :success
  end

  test "should get edit" do
    get edit_sub_task_url(@sub_task)
    assert_response :success
  end

  test "should update sub_task" do
    patch sub_task_url(@sub_task), params: { sub_task: { content: @sub_task.content, task_id: @sub_task.task_id } }
    assert_redirected_to sub_task_url(@sub_task)
  end

  test "should destroy sub_task" do
    assert_difference('SubTask.count', -1) do
      delete sub_task_url(@sub_task)
    end

    assert_redirected_to sub_tasks_url
  end
end
