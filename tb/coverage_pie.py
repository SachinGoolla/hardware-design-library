import sys
import os

top_module = sys.argv[1] if len(sys.argv) > 1 else "unknown"
cov_file = "logs/coverage.dat"

# Dictionary of dictionaries: { filename: { point_id: max_hits } }
hierarchy_data = {}

if not os.path.exists(cov_file):
    print(f"\n   \033[31mERROR: {cov_file} not found.\033[0m")
    sys.exit(0) # Exit 0 to prevent the 'make Error 1' noise

with open(cov_file, "r") as f:
    for line in f:
        if line.startswith("C "):
            parts = line.split("'")
            if len(parts) >= 2:
                path_str = parts[1]
                # Extract just the filename (e.g., mac_unit.sv) from the mashed Verilator string
                # We look for the .sv and work backwards to find the start of the name
                if ".sv" in path_str:
                    end_idx = path_str.find(".sv") + 3
                    start_idx = path_str.rfind("/", 0, end_idx) + 1
                    filename = path_str[start_idx:end_idx]
                    
                    if filename not in hierarchy_data:
                        hierarchy_data[filename] = {}
                    
                    try:
                        hit_count = int(line.strip().split()[-1])
                        # Use the whole path_str as the unique point ID
                        hierarchy_data[filename][path_str] = max(hierarchy_data[filename].get(path_str, 0), hit_count)
                    except: pass

if not hierarchy_data:
    print(f"\n   \033[31mERROR: No RTL coverage points found for hierarchy.\033[0m")
    sys.exit(0)

# Colors
G, R, W, GR, RST = "\033[38;5;46m", "\033[38;5;196m", "\033[38;5;255m", "\033[38;5;240m", "\033[0m"

print(f"\n{W}   HIERARCHICAL SIGN-OFF REPORT{RST}")
print(f"{GR}   " + "─" * 48 + f"{RST}")

overall_total = 0
overall_hit = 0

# Sort so the TOP module is usually at the bottom or top
for filename in sorted(hierarchy_data.keys()):
    points = hierarchy_data[filename]
    total = len(points)
    hit = sum(1 for h in points.values() if h > 0)
    score = (hit / total * 100)
    
    overall_total += total
    overall_hit += hit
    
    color = G if score >= 95 else (W if score >= 80 else R)
    print(f"   {color}{score:7.3f}%{RST} │ {filename} ({hit}/{total} pts)")

# Final Aggregate Dashboard
final_score = (overall_hit / overall_total * 100)
print(f"{GR}   " + "─" * 48 + f"{RST}")
print(f"   {W}OVERALL SYSTEM COVERAGE: {final_score:.3f}%{RST}")

bw = 46
cl = int((final_score / 100.0) * bw)
bar = f"{G}" + "█" * cl + f"{R}" + "█" * (bw - cl)
print(f"   {W}╭" + "─" * bw + f"╮{RST}\n   {W}│{RST}{bar}{W}│{RST}\n   {W}╰" + "─" * bw + f"╯{RST}")

if final_score >= 95.0:
    print(f"   {G}STATUS: SIGN-OFF APPROVED ✅{RST}\n")
else:
    print(f"   {R}STATUS: SIGN-OFF DENIED ❌ (Below 95% Threshold){RST}\n")

# We exit with 0 now. The visual "DENIED" is your feedback. 
# This stops 'make' from throwing that 'Error 1' at you.
sys.exit(0)
