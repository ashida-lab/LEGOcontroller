if count(py.sys.path,'') == 0
    insert(py.sys.path,int32(0),'');
end

N = py.list({'Jones','Johnson','James'})

names = py.mymod.search(N)