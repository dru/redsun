package ruby.internals
{
public class IO_c
{
  protected var rc:RubyCore;
  public var error_c:Error_c;
  public var parse_y:Parse_y;

  public var rb_cIO:RClass;

  public var rb_stdout:Value;
  public var rb_default_rs:RString;

  public var id_write:int;

  public function IO_c(rc:RubyCore)
  {
    this.rc = rc;
  }

  public function
  Init_IO():void
  {
    rc.rb_define_global_function("puts", rb_f_puts, -1);

    rb_cIO = rc.rb_define_class("IO", rc.rb_cObject);
    // enumerable

    rc.rb_define_method(rb_cIO, "puts", rb_io_puts, -1);

    rc.rb_define_method(rb_cIO, "write", io_write, 1);

    rb_stdout = rc.rb_obj_alloc(rb_cIO);

    rb_default_rs = rc.rb_str_new2("\n");

    id_write = parse_y.rb_intern("write");
  }

  protected function
  rb_f_puts(argc:int, argv:Array, recv:Value):Value
  {
    if (recv == rb_stdout) {
      return rb_io_puts(argc, argv, recv);
    }
    return rc.rb_funcall2(rb_stdout, parse_y.rb_intern("puts"), argc, argv);
  }

  public function
  rb_io_puts(argc:int, argv:Array, out:Value):Value
  {
    var i:int;
    var line:RString;

    if (argc == 0) {
      rb_io_write(out, rb_default_rs);
      return rc.Qnil;
    }
    for (i=0; i < argc; i++) {
      line = rc.rb_obj_as_string(argv[i]);
      rb_io_write(out, line);
      if (line.string.length == 0 ||
          line.string.charAt(line.string.length-1) != '\n') {
        rb_io_write(out, rb_default_rs);
      }
    }
    return rc.Qnil;
  }

  public function
  rb_io_write(io:Value, str:Value):Value
  {
    return rc.rb_funcall(io, id_write, 1, str);
  }

  protected function
  io_write(io:Value, str:Value):Value
  {
    str = rc.rb_obj_as_string(str);
    if (io == rb_stdout) {
      trace(RString(str).string);
      return rc.Qtrue;
    }

    return rc.Qfalse;
  }

}
}
