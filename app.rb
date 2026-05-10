# frozen_string_literal: true

require 'webrick'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'json'
require 'erb'
require 'pg'

DB = PG.connect(dbname: 'memo_app')

DB.exec <<~SQL
  CREATE TABLE IF NOT EXISTS memos (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL
  )
SQL

helpers do
  include ERB::Util
end

def load_memos
  DB.exec('SELECT * FROM memos')
end

def find_memo(id)
  result = DB.exec_params('SELECT * FROM memos WHERE id = $1', [id])
  result.first
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  memos = load_memos
  erb :index, locals: { memos: memos }
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memo = find_memo(params[:id])
  halt 404 unless memo
  erb :show, locals: { memo: memo }
end

get '/memos/:id/edit' do
  memo = find_memo(params[:id])
  halt 404 unless memo
  erb :edit, locals: { memo: memo }
end

post '/memos' do
  title = params['title']
  content = params['content']

  DB.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2)', [title, content])

  redirect '/memos'
end

patch '/memos/:id' do
  memo = find_memo(params[:id])
  halt 404 unless memo

  DB.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3',
                 [params[:title], params[:content], params[:id]])

  redirect "/memos/#{memo['id']}"
end

delete '/memos/:id' do
  DB.exec_params('DELETE FROM memos WHERE id = $1', [params[:id]])

  redirect '/memos'
end

not_found do
  erb :not_found, layout: false
end
