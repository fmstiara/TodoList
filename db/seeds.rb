# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Todo.create(title: "大学")
Todo.create(title: "会社")

Task.create(content: "レポート", todo_id: 1)
Task.create(content: "レジュメ", todo_id: 1)
Task.create(content: "研修", todo_id: 2)
Task.create(content: "設計", todo_id: 2)
Task.create(content: "開発", todo_id: 2)