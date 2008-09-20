class Manage::CategoriesController < Manage::ManageController
  
  skip_before_filter :verify_authenticity_token,:only => [:create,:update]
  
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.find(:all,:conditions => "user_id = #{current_user.id}")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @category }
    end
  end
  
  
  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])
    @category.user_id = current_user.id
    if @category.save
      render :update do |page|
        page['notice_text'].replace_html :partial => "/manage/categories/success_notice"
        page.insert_html(:bottom,"category_table",:partial => "/manage/categories/success_tr",:locals => {:category => @category})
        page["t_#{@category.id}"].visual_effect :highlight
        page["onload_img"].hide
      end
    else
      render :update do |page|
        page['notice_text'].replace_html :partial => "/manage/categories/error_notice",:locals => {:category => @category}
      end
    end
  end

  def delete
    if Category.find(params[:id]).destroy
      render :update do |page|
        page["t_#{params[:id]}"].visual_effect :blind_down 
        page["t_#{params[:id]}"].remove
      end
    else
      render :update do |page|
        page["t_#{params[:id]}"].visual_effect :highlight
      end
    end
  end

  def ajax_new
    @category = Category.new
    unless params[:category_name].blank?
      @category.name = params[:category_name]
      @category.user_id = current_user.id
      render :text =>  @category.save ? @category.id : @category.errors.full_messages.join(';')
    else
      render :text => "请输入类别名称"
    end
    return true
  end
  
  def ajax_update
    @category = Category.find(params[:id])
    if params[:category_name].blank?
      render :update do |page|
        @category.errors.add_to_base("请输入类别名称")
        page['notice_text'].replace_html :partial => "/manage/categories/error_notice",:locals => {:category => @category}
      end
      return false
    end
    if @category.update_attribute(:name,params[:category_name])
      render :update do |page|
        page["t_#{@category.id}_edit"].replace_html :partial => "/manage/categories/category_td_edit",:locals => {:category => @category}
        page["t_#{@category.id}_edit"].hide
        page["t_#{@category.id}"].replace_html :partial => "/manage/categories/category_td",:locals => {:category => @category}
        page["t_#{@category.id}"].show
      end
    else
      render :update do |page|
        page['notice_text'].replace_html :partial => "/manage/categories/error_notice",:locals => {:category => @category}
      end
    end
    return true
  end
  
  
  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])
    @category.update_attributes(params[:category])
    render :update do |page|
      page["t_#{@category.id}_edit"].replace_html :partial => "/manage/categories/category_td_edit",:locals => {:category => @category}
      page["t_#{@category.id}_edit"].hide
      page["t_#{@category.id}"].replace_html :partial => "/manage/categories/category_td",:locals => {:category => @category}
      page["t_#{@category.id}"].show
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end
  
end
