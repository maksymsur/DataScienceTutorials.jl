# This file was generated, do not modify it. # hide
figure(figsize=(8,6))

res = ŷ .- y[test]
stem(res)

xticks(fontsize=12); yticks(fontsize=12)
xlabel("Index", fontsize=14);
ylabel("Residual (ŷ - y)", fontsize=14)
xlim(1, length(res))

ylim([-1300, 1000])

savefig(joinpath(@OUTPUT, "ISL-lab-6-g5.svg")) # hide