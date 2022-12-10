# frozen_string_literal: true

class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[landing_page privacy_policy]

  def landing_page
  end

  def privacy_policy
  end

  def calendar
    @users = User.order(email: :asc).teacher
    #@classrooms = Classroom.order(name: :asc)
    @courses = Course.order(id: :desc)

    if params.key?(:user_id)
      lessons = Lesson.includes(:user, :course, :attendances)
      @user = params[:user_id]
      #@classroom = params[:classroom_id]
      @course = params[:course_id]

      lessons = lessons.where(user_id: @user) if @user.present?
      #lessons = lessons.where(classroom_id: @classroom) if @classroom.present?
      lessons = lessons.where(course_id: @course) if @course.present?
      current_user_lessons = !current_user.teacher? ?
         Attendance.where(user_id: current_user).pluck(:lesson_id) : Lesson.where(user_id: current_user)
      @lessons = lessons.where(id: current_user_lessons)
    else
      lessons = Lesson.includes(:user, :course, :attendances)
      current_user_lessons = !current_user.teacher? ?
                               Attendance.where(user_id: current_user).pluck(:lesson_id) : Lesson.where(user_id: current_user)
      @lessons = lessons.where(id: current_user_lessons)
    end
  end
end
