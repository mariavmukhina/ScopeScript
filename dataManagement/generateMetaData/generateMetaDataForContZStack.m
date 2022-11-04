function metaDataList = generateMetaDataForContZStack(flattenedInstructions,fcScope)
%GENERATEMETADATAFORCONTZSTACK will generate a list of metaDatas that
%correspond to TTLtriggers
% metaData{TTLtrigger1}{1}   > one direction
% metaData{TTLtrigger1}{2}   < the other direction
% metaData{TTLtrigger2}{1} ...

TTLtriggers = unique(flattenedInstructions.mergedEnergyChannels);
metaDataList = cell(numel(TTLtriggers),1);
zparams = flattenedInstructions.dacInstructions{1}.params{1};
for i = 1:numel(TTLtriggers)
    index = find(TTLtriggers(i) == flattenedInstructions.mergedEnergyChannels,1,'first');
    TTLtriggerName = mapTTLPinToChannel(TTLtriggers(i));
    zMetaOtherDir.z0 = (zparams.N-1)*300;
    zMetaOtherDir.dz = -zparams.dz;
    zMetaOtherDir.N  = zparams.N;
    zMeta.TTLtrigger = TTLtriggerName;
    zparams.TTLtrigger = TTLtriggerName;
    zMeta.zParams = zparams;
    meta1 = genMetaData(fcScope,zMeta);
    zMeta.zParams = zMetaOtherDir;
    meta2 = genMetaData(fcScope,zMeta);
    metaDataList{index}{1} = meta1;
    metaDataList{index}{2} = meta2;
end

end

