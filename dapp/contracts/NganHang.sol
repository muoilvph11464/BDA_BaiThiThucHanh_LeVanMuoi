// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract NganHang is Ownable{
    
    IERC20 public KhoTien;
    
    
    //Tong So giao dich
    uint public SoLuongGiaoDich;
    
    //PhanTramGiaoDich
    uint8 public TiLePhiGiaoDich;
    
    
    //BienLaiGiaoDich
    struct GiaoDich{
        address NguoiGui;
        address NguoiNhan;
        uint    ThoiGianGui;
        uint    SoTien;
        uint    PhiGiaoDich;
    }
    
    // ma bien lai => bien lai
    mapping (uint => GiaoDich) public DanhSachTatCaGiaoDich;
    
    // dia chi gui => mang ma bien lai
    mapping (address => uint[]) public DanhSachGiaoDichGui;
    
    // dia chi nhan => mang ma bien lai
    mapping (address => uint[]) public DanhSachGiaoDichNhan;
    
    constructor(address _KhoTien,uint8 _TiLePhiGiaoDich){
        KhoTien = IERC20(_KhoTien);
        SoLuongGiaoDich = 0;
        TiLePhiGiaoDich = _TiLePhiGiaoDich;
    }
    
    event ThayDoiPhanTramGiaoDichThanhCong();
    
    event ChuyenTienThanhCong();
    
    // ThayDoiPhanTramGiaoDich
    function ThayDoiPhanTramGiaoDich(uint8 _TiLePhiGiaoDich) public onlyOwner{
        require(_TiLePhiGiaoDich>0,"Pham tram giao dich phai lon hon 0 !");
        
        TiLePhiGiaoDich = _TiLePhiGiaoDich;
        
        emit ThayDoiPhanTramGiaoDichThanhCong();
    }
    
    // ChuyenTien
    function ChuyenTien(address _NguoiNhan, uint _SoTien) public{
        
        // Kiem tra so tien nguoi gui
        require ( KhoTien.balanceOf(msg.sender) >= _SoTien, "So tien trong vi khong du !");
        
        require ( msg.sender != _NguoiNhan,"Nguoi nhan va nguoi gui phai khac nhau!");
        
        uint _MaBienLai = SoLuongGiaoDich +1;
        
        SoLuongGiaoDich +=1;
        
        uint _PhiGiaoDich = _SoTien*TiLePhiGiaoDich/10000;
        
        DanhSachTatCaGiaoDich[_MaBienLai] = GiaoDich({NguoiGui: msg.sender, NguoiNhan:_NguoiNhan,ThoiGianGui:block.timestamp,SoTien:_SoTien,PhiGiaoDich:_PhiGiaoDich});
        
        DanhSachGiaoDichGui[msg.sender].push(_MaBienLai);
        
        DanhSachGiaoDichNhan[_NguoiNhan].push(_MaBienLai);
        
        KhoTien.transferFrom(msg.sender,address(this),_SoTien);
        
        KhoTien.transfer(owner(),_PhiGiaoDich);
        
        uint _SoTienGuiVe = _SoTien - _PhiGiaoDich;
        
        KhoTien.transfer(_NguoiNhan,(_SoTienGuiVe));
        
        emit ChuyenTienThanhCong();
    }
    
    // Lay Danh Sach Nhan Tien
     function LayDanhSachGiaoDichNguoiNhan(address _NguoiNhan) public view returns(uint[] memory) {
        return DanhSachGiaoDichNhan[_NguoiNhan];
    }
    
    // Lay Danh Sach Nhan Tien
     function LayDanhSachGiaoDichNguoiGui(address _NguoiGui) public view returns(uint[] memory) {
        return DanhSachGiaoDichGui[_NguoiGui];
    }
}