for file in `cat ./vhdl_analyze_order`
do
  echo "# ghdl ... primitive/$file"
  ghdl -a -fexplicit --ieee=synopsys --work=simprim \
      --no-vital-checks ./$file 2>&1 |\
      tee ./$file.ghdl.log
done

