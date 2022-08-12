Data used:
=

Kuramoto Oscillator data:
--
8x32_10000.mat 			Data generated using 'generate_kuramoto_data.m' script


KET data:
--
021013_51_KET.mat

021013_51_PLA.mat

040806_1_KET.mat

040806_1_PLA.mat

041213_1_KET.mat

041213_1_PLA.mat

091013_KET.mat

091013_PLA.mat

110913_KET.mat

110913_PLA.mat

161013_51_KET.mat

161013_51_PLA.mat

171212_1_KET.mat

171212_1_PLA.mat

18113_1_KET.mat

18113_1_PLA.mat

210813_51_KET.mat

210813_51_PLA.mat

310713_51_KET.mat

310713_51_PLA.mat



Scripts:
=
generate_kuramoto_data.m		Generates Kuramoto oscillator data

gauss_vs_discrete.m 			Compares the discretisation method on three different macro variables of Kuramoto oscillator data (figure 2)

gauss_vs_discrete_meg.m 		Uses the GA on one MEG data and then discretises variables for comparison (figure 3)

ga_kuramoto.m				Uses the GA on the Kuramoto oscillator data (figure 4)

ga_retestability.m 			Uses the GA 10 separate times on the same data (figures 5, 6)

all_participants_ga.m 			Uses the GA on each participant in each condition separately (figure 7)

ga_meg.m				Uses the GA on the MEG data in different scenarios (figure 8)



For scripts to work, you will need the data listed above and to change the location of the files to your file location(s) when they are loaded in the scripts.
