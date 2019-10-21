# DWCでよく使うGem入門

- [cocoon](https://github.com/nathanvda/cocoon)
- [paranoia](https://github.com/rubysherpas/paranoia)
- [ransacl](https://github.com/activerecord-hackery/ransack)
<<<<<<< HEAD
=======

# branch情報
- [master](https://github.com/fmstiara/TodoList/tree/master)
  - gemを試すのに必要な内容を下準備したもの
- [goal](https://github.com/fmstiara/TodoList/tree/goal)
  - コード完成形
>>>>>>> master

# やること
- Todo(親) < Task(子)をまとめて保存する
- cocoonを使い動的にTaskを増やせるようにする
- paranoiaを使いTaskを論理削除
- ransackを使いtodoとtaskから検索する

# DB情報
- todosテーブル
  - title:string
- tasksテーブル
  - content:text
  - todo_id:integer
- sub_tasksテーブル
  - content:text
  - task_id:integer

Todo(親) ＜ Task(子) < SubTask(孫)

# 親子関係でまとめて保存する
- views
  - fields_forを使い、別モデルのformを構成する
  ```erb
    <%# views/todos/_form.html.erb %>
    <%= form.fields_for :tasks do |tform| %>
      <%= render 'task_fields', f: tform %>
    <% end %>
  ```
  ```erb
    <%# views/todos/_tasks_fields.html.erb%>
    <div class='nested-fields'>
      <%= f.label :content %>
      <%= f.text_field :content %>
    </div>
  ```
- controller
  - strong paramtersにxxxxs_attributesの記載を加え、子モデルのparameterを受け取れるようにする
  - @todo.tasks.newで空の子レコードを生成。これをしないとtaskの入力欄は生成されない。
  ```ruby
    # controllers/todos_controller.rb
    def new
      @todo = Todo.new
      @todo.tasks.new
    end

    private
      def todo_params
        #:idと:_destroyはtaskレコードの削除に必要
        params.require(:todo).permit(:title, tasks_attirbutes: [:id, :content, :_destory])
      end
  ```
- model
  - accepts_nested_attributes_forを使い、親子をまとめて保存するようにする
  - `allow_destroy: true`のオプションにより、関連モデルの削除も同時にできる(:idと:_destroyをpermitしていることが前提)
  ```ruby
    #models/todo.rb
    accepts_nested_attributes_for :tasks, allow_destroy: true
  ```
# cocoon
- views
  - link_to_add_associationで入力欄追加
    デフォルトでは、link_to_add_associationタグの親の位置にformを追加する
    ```erb
      <%# views/todos/_form.html.erb%>
      <div class="links">
        <%= link_to_add_association "Task追加", form, :tasks %>
      </div>
    ```
  - link_to_remove_associationで入力欄削除
    - 削除はlink_to_remove_associationがあるタグの親に.nested-fieldsクラスを持ったdivタグの中に記述する必要がある(オプションで変更可能)
    ```erb 
      <%# views/todos/_tasks_fields.html.erb %>
      <div class='nested-fields'>
        <%= f.label :content %>
        <%= f.text_field :content %>
        <%= link_to_remove_association "削除", f%>
      </div>
    ```

# paranoia
- model
  - 論理削除したいモデル(テーブル)にdeleted_at:datetime型を用意する
  - 論理削除したモデルにacts_as_paranoidを記述する
  - これだけで、destroyメソッドが走ったときにdeleted_atに、その時点の時刻が値として入り、削除が表現される(=論理削除)
    - 子モデルのtaskだけ論理削除できる状態で、todoを物理削除してしまうと、taskレコードが参照するtodo_idが消えてしまう。
    - 親のtodoも論理削除できるようにする、もしくはtodoを物理削除したとき、子レコードも物理削除する。(ここでは前者を採用)
  ```ruby
    # models/todo.rb
    class Todo < ApplicationRecord
      acts_as_paranoid
      ...
    end
  ```
  ```ruby
    # models/task.rb
    class Task < ApplicationRecord
      acts_as_paranoid
      ...
    end
  ```
  - 論理削除した値を取得するときはwith_deleatedの記述を加える
  ```ruby
    # 例
    Todo.with_deletd
  ```
  - has_manyやbelongs_toにwith_deletedを組み込むことができる。
  ```ruby
    #models/todo.rb
    class Todo < ApplicationRecord
      acts_as_paranoid
      has_many :tasks, -> { with_deleted }
      accepts_nested_attributes_for :tasks, allow_destroy: true
    end
  ```

# ransack
- controller
  - ransackで検索するためのobjectを生成する
  ```ruby
    # controllers/application_controoler.rb
    # ヘッダーに検索欄を設けているので、どのページでも@qを存在させるために
    # application_controllerに記述する
    before_action :set_search
    def set_search
      @q = Todo.ransack(params[:q])
    end
  ```
  - ransackの検索結果を取得する
  ```ruby
    # controllers/todos_controller.rb
    # @qはapplication_controllerで定義済み
    def index
      @todos = @q.result(distinct: true)
    end
  ```
- views
  - 検索条件をviewで定義する
    - `:title_or_tasks_content_cont`で「todoのtitleもしくはtaskのcontentであいまい検索」になる
    - このようにリレーション関係にあるモデルも簡単に検索できる
  ```erb
    <%# views/layouts/_header.html.erb %>
    <%= search_form_for @q do |f| %>
      <%= f.label :title_or_tasks_content_cont, "ToDo検索" %>
      <%= f.search_field :title_or_tasks_content_cont %>
      <%= f.submit "検索" %>
    <% end %>
  ```
