json.extract! task, :id, :content, :todo_id, :created_at, :updated_at
json.url task_url(task, format: :json)
