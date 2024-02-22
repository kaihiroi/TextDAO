// SPDX-License-Identifier: MIT
// OrgDB Contracts (last update v0.1.0)

pragma solidity ^0.8.21;

// Configs
import {IOrgConfigs} from "./configs/IOrgConfigs.sol";
import {IOrgConsts} from "./configs/structs/IOrgConsts.sol";
import {IOrgMetadata} from "./configs/structs/IOrgMetadata.sol";
import {IOrgVars} from "./configs/structs/IOrgVars.sol";
// Departments
import {IOrgDepartments} from "./departments/IOrgDepartments.sol";
// Deliberation
import {IOrgDeliberation} from "./deliberation/IOrgDeliberation.sol";
import {IProposal} from "./deliberation/structs/IProposal.sol";
import {IStakedStatus} from "./deliberation/structs/IStakedStatus.sol";
import {IVotingStatus} from "./deliberation/structs/IVotingStatus.sol";
// Decisions
import {IOrgDecisions} from "./decisions/IOrgDecisions.sol";
import {IBudget} from "./decisions/structs/IBudget.sol";
import {IDoc} from "./decisions/structs/IDoc.sol";
// Finance
import {IOrgFinance} from "./finance/IOrgFinance.sol";
// Lock
import {IOrgLock} from "./lock/IOrgLock.sol";
// Dictionary
import {DictionaryUtils} from "src/dictionary-pattern/dictionary-user-proxy/DictionaryUserProxy.sol";


/// @dev The information about this exception is documented in (docs/specs/Operation.md)
abstract contract OrgProxyStorageLayout is
    IOrgConfigs,
    IOrgDepartments,
    IOrgDeliberation,
    IOrgDecisions,
    IOrgFinance,
    IOrgLock,
    DictionaryUtils
{
    struct OrgStorage {
        mapping(bytes32 key00 => OrgConfigs) configs;
        mapping(bytes32 key01 => address[]) members;
        mapping(bytes32 key02 => OrgDepartments) deps;
        mapping(bytes32 key03 => OrgDeliberation) deliberation;
        mapping(bytes32 key04 => OrgDecisions) decisions;
        mapping(bytes32 key05 => OrgFinance) finance;
        mapping(bytes32 key06 => OrgLock) lock;
    }

    /**
        @dev KEYs are the keccak-256 hashes of each seed words subtracted by 1
        [KEY]                           [seed word]
        _ORG_CONFIGS                    "org.configs"
        _ORG_CONFIGS_METADATA           "org.configs.metadata"
        _ORG_CONFIGS_VARS               "org.configs.vars"
        _ORG_CONFIGS_CONSTS             "org.configs.consts"
        _ORG_MEMBERS                    "org.members"
        _ORG_DEPARTMENTS                "org.departments"
        _ORG_DEPARTMENTS_FORKS          "org.departments.forks"
        _ORG_DEPARTMENTS_ANONGROUPS     "org.departments.anonGroups"
        _ORG_DELIBERATION               "org.deliberation"
        _ORG_DELIBERATION_PROPOSALS     "org.deliberation.proposals"
        _ORG_DELIBERATION_VOTINGSTATUS  "org.deliberation.votingStatus"
        _ORG_DELIBERATION_STAKEDSTATUS  "org.deliberation.stakedStatus"
        _ORG_DECISIONS                  "org.decisions"
        _ORG_DECISIONS_BUDGETS          "org.decisions.budgets"
        _ORG_DECISIONS_DOCS             "org.decisions.docs"
        _ORG_FINANCE                    "org.finance"
        _ORG_FINANCE_RECEIVED           "org.finance.received"
        _ORG_FINANCE_PROPOSALDEPOSIT    "org.finance.proposalDeposit"
        _ORG_LOCK                       "org.lock"
        _ORG_LOCK_BLOCKOPCOUNTERS       "org.lock.blockOpCounters"
        _ORG_LOCK_ISORGPAUSED           "org.lock.isOrgPaused"
     */
    bytes32 internal constant _ORG_CONFIGS                   = 0x143d7928b1ae3ca82450eaf6dc8601c10ad3b8b2932bbdd5ea9bc1c0bc73dfc7;
    bytes32 internal constant _ORG_CONFIGS_METADATA          = 0x3ce6e50e6c7df8ad300cd918ba1bd5889e8b7f46ba571098ad999ea1278be761;
    bytes32 internal constant _ORG_CONFIGS_VARS              = 0x6e7007184ebb04bb9a2f8b27cc7fb622bf43370802d5623a323b5bb21f6a7b71;
    bytes32 internal constant _ORG_CONFIGS_CONSTS            = 0x79eac6e3b02604ae69ac811876a465d5ad2e434211a906c44ee2636bde106805;
    bytes32 internal constant _ORG_MEMBERS                   = 0xd990565c4538624ec6651899629dc439b372e6913da4fe01fb63025586001df6;
    bytes32 internal constant _ORG_DEPARTMENTS               = 0xedf0c9609e49de62b10e61aa13fe7adffb9e53317f6437d8404d51de294bf3f6;
    bytes32 internal constant _ORG_DEPARTMENTS_FORKS         = 0x0afdd12bef92d8de3b80fe83ee23ccc156339a9993be688c553e614fd0ad3bee;
    bytes32 internal constant _ORG_DEPARTMENTS_ANONGROUPS    = 0x78b93c1e12da24b6f89668e7b075049b72ee86c1a17d47ad092c1253196adb6e;
    bytes32 internal constant _ORG_DELIBERATION              = 0x2edee5f50a3c369ebf11b3e4d0fd1d96535fbfc62b258692ae20801cb53d47c0;
    bytes32 internal constant _ORG_DELIBERATION_PROPOSALS    = 0xb4532477c6c284e20ca330712584d40557534f616c310853173a73f136726021;
    bytes32 internal constant _ORG_DELIBERATION_VOTINGSTATUS = 0xd21976d1c4a1d73db2111a1d8bd956868d5251d9c1f9758eb50dd7b4febccf95;
    bytes32 internal constant _ORG_DELIBERATION_STAKEDSTATUS = 0xc5f476e4d8f444646197ca6d963f5d1511dd9d5e320e65912f80b61d138cbd13;
    bytes32 internal constant _ORG_DECISIONS                 = 0xc1c439d75b089b605c103727341f25e9031081c74996f2df605995d9e34fa898;
    bytes32 internal constant _ORG_DECISIONS_BUDGETS         = 0xbceaffc9e95cad606c0c59b574186b8b67b3c25f4fef78f4b864c401e4289ab6;
    bytes32 internal constant _ORG_DECISIONS_DOCS            = 0x078802b863fc83257f367b1ef59a88a87ac3e294cd85fca2d2eeedd5c32b5b63;
    bytes32 internal constant _ORG_FINANCE                   = 0x2d58ab1f8c839d5f3a8f27753ef006b0513e82834485d7576a431714fc8f32fd;
    bytes32 internal constant _ORG_FINANCE_RECEIVED          = 0xc853b878f4a0dc48eb5db98f3f4c6c63b771e54303b7aab6ca89087c08ee68be;
    bytes32 internal constant _ORG_FINANCE_PROPOSALDEPOSIT   = 0x422ef2f972221d33ee0c4b37924019682ae0b49b8456d5fecfa1a72facd616f8;
    bytes32 internal constant _ORG_LOCK                      = 0xacbf2baf96dc5cb40a57992ac9459ce054afe8d2e1ef16a8ad2982bf5882c6c4;
    bytes32 internal constant _ORG_LOCK_BLOCKOPCOUNTERS      = 0x9fc3c37c2444aaa573e865a2a377c40f016b4617b8d9844d77d16204dc211580;
    bytes32 internal constant _ORG_LOCK_ISORGPAUSED          = 0x37654edcc8fc12ae6a44c2a6e6c3183a7cb020b49e94047f6dccf4d6924189a9;
}
