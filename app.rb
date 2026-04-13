# frozen_string_literal: true

require 'webrick'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'json'
require 'erb'

helpers do
  include ERB::Util
end

def load_memos
  JSON.parse(File.read('memos.json'))
end

def save_memos(memos)
  File.write('memos.json', JSON.pretty_generate(memos))
end

def find_memo(memos, id)
  memos.find { it['id'] == id.to_i }
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
  memos = load_memos
  memo = find_memo(memos, params[:id])
  halt 404 unless memo
  erb :show, locals: { memo: memo }
end

get '/memos/:id/edit' do
  memos = load_memos
  memo = find_memo(memos, params[:id])
  halt 404 unless memo
  erb :edit, locals: { memo: memo }
end

post '/memos' do
  title = params['title']
  content = params['content']

  memos = load_memos
  id = memos.map { |memo| memo['id'] }.max.to_i + 1

  memos << { 'id' => id, 'title' => title, 'content' => content }
  save_memos(memos)

  redirect '/memos'
end

patch '/memos/:id' do
  memos = load_memos
  memo = find_memo(memos, params[:id])
  halt 404 unless memo

  memo['title'] = params[:title]
  memo['content'] = params[:content]
  save_memos(memos)

  redirect "/memos/#{memo['id']}"
end

delete '/memos/:id' do
  memos = load_memos

  memos.reject! { |m| m['id'] == params[:id].to_i }

  save_memos(memos)

  redirect '/memos'
end
