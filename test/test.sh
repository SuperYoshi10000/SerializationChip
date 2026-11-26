source .venv/bin/activate
make clean
make
python -m cocotb_tools.check_results results.xml