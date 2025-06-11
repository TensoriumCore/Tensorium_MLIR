import lit.formats

config.name = 'Relativity Tests'
config.test_format = lit.formats.ShTest(True)
config.suffixes = ['.mlir']
config.test_source_root = os.path.dirname(__file__)
config.test_exec_root = os.path.join(config.my_obj_root, 'test')

config.substitutions.append(('%relativity-opt', 
  os.path.join(config.my_obj_root, 'tools', 'relativity-opt')))
