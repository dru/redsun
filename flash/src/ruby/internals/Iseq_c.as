
  public var rb_cISeq:RClass;

  public var COMPILE_OPTION_DEFAULT:RbCompileOptions;

  protected function iseq_alloc(klass:RClass):Value {
    var obj:Value;
    var iseq:RbISeq;

    obj = Data_Wrap_Struct(klass, new RbISeq(), null/*iseq_mark*/, null/*iseq_free*/);
    return obj;
  }

  public function rb_iseq_new(node:Node, name:Value, filename:Value, parent:Value, type:uint):Value {
    return rb_iseq_new_with_opt(node, name, filename, parent, type, COMPILE_OPTION_DEFAULT);
  }

  public function GetISeqPtr(obj:Value):RbISeq {
    return GetCoreDataFromValue(obj);
  }

  protected function
  prepare_iseq_build(iseq:RbISeq,
                     name:Value, filename:Value,
                     parent:Value, type:uint, block_opt:Value,
                     option:RbCompileOptions):Value
  {
    iseq.name = name;
    iseq.filename = filename;
    iseq.defined_method_id = 0;
    iseq.mark_ary = null; //rb_ary_new();
    //RBasic(iseq.mark_ary).klass = null;

    iseq.type = type;
    iseq.arg_rest = -1;
    iseq.arg_block = -1;
    iseq.klass = null;

    // bunch more code

    iseq.coverage = Qfalse;

    return Qtrue;
  }

  public function
  rb_iseq_new_with_bopt_and_opt(node:Node, name:Value, filename:Value,
                                parent:Value, type:uint, bopt:Value,
                                option:RbCompileOptions):Value
  {
    var iseq:RbISeq;
    var self:Value = iseq_alloc(rb_cISeq);

    iseq = GetISeqPtr(self);
    iseq.self = self;

    prepare_iseq_build(iseq, name, filename, parent, type, bopt, option);
    iseq_compile(self, node);
    cleanup_iseq_build(iseq);

    return self;
  }

  protected function
  cleanup_iseq_build(iseq:RbISeq):Value
  {
    // skipping this
    return Qtrue;
  }

  public function
  iseq_compile(self:Value, node:Node):int {
    var ret:*;
    var iseq:RbISeq;
    iseq = GetISeqPtr(self);

    if (node == null) {
      //COMPILE(ret, "nil", node);
      //iseq_set_local_table(iseq, 0);
    } else {
      rb_bug("should not have a call to compile in Red Sun");
    }

    return iseq_setup(iseq, ret);
  }

  protected function
  iseq_setup(iseq:RbISeq, anchor:*):int
  {
    return 0;
  }

  // iseq.c:328
  public function rb_iseq_new_with_opt(node:Node, name:Value, filename:Value, parent:Value, type:uint, option:RbCompileOptions):Value {
    return rb_iseq_new_with_bopt_and_opt(node, name, filename, parent, type, null, option);
  }



  public function Init_ISeq():void {
    COMPILE_OPTION_DEFAULT = new RbCompileOptions();

    rb_cISeq = rb_define_class_under(rb_cRubyVM, "InstructionSequence", rb_cObject);

    // TODO: @skipped
    // more methods
  }

  // iseq.c:930
  public function
  ruby_node_name(type:uint):String
  {
    return "Node :" + type;
  }

