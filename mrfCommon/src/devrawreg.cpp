/*************************************************************************\
* Copyright (c) 2017 Michael Davidsaver
* mrfioc2 is distributed subject to a Software License Agreement found
* in file LICENSE that is included with this distribution.
\*************************************************************************/

#include <stdexcept>

#include <epicsMMIO.h>

#include <mrf/object.h>
#include <mrf/rawreg.h>

void mrf::RawRegisterAccess::getRegisterOffset(unsigned region,
                                               unsigned offset,
                                               volatile void** addr,
                                               access_t* perm)
{
    throw std::runtime_error("Raw register access not supported");
}

namespace {

struct RawRegister : public mrf::ObjectInst<RawRegister>
{
    typedef mrf::ObjectInst<RawRegister> base_t;

    const mrf::Object * const parent;
    volatile void * addr;
    mrf::RawRegisterAccess::access_t perm;

    explicit RawRegister(const std::string& name, const mrf::Object* parent)
        :base_t(name)
        ,parent(parent)
        ,addr(0)
        ,perm(mrf::RawRegisterAccess::NoAccess)
    {}
    virtual ~RawRegister() {}

    static mrf::Object* buildReg(const std::string& name, const std::string& klass, const mrf::Object::create_args_t& args)
    {
        epicsUInt32 offset=0;
        {
            mrf::Object::create_args_t::const_iterator it=args.find("OFFSET");
            if(it==args.end())
                throw std::runtime_error("No OFFSET= specified");

            if(epicsParseUInt32(it->second.c_str(), &offset, 0, 0)) {
                throw std::runtime_error("Invalid OFFSET");
            }
        }

        epicsUInt32 region=0;
        {
            mrf::Object::create_args_t::const_iterator it=args.find("REGION");
            if(it!=args.end()&& epicsParseUInt32(it->second.c_str(), &region, 0, 0)) {
                throw std::runtime_error("Invalid REGION");
            }
        }

        mrf::Object *mgrobj;
        mrf::RawRegisterAccess *source;
        {
            mrf::Object::create_args_t::const_iterator it=args.find("PARENT");
            if(it==args.end())
                throw std::runtime_error("No PARENT= specified");

            mgrobj = mrf::Object::getObject(it->second);
            if(!mgrobj)
                throw std::runtime_error("No such PARENT object");

            source = dynamic_cast<mrf::RawRegisterAccess*>(mgrobj);
            if(!source)
                throw std::runtime_error("Object does not provide RawRegisterAccess");
        }

        mrf::auto_ptr<RawRegister> ret(new RawRegister(name, mgrobj));

        source->getRegisterOffset(region, offset, &ret->addr, &ret->perm);

        return ret.release();
    }

    virtual void lock() const {parent->lock();}
    virtual void unlock() const {parent->unlock();}

    void check_write() const {
        if(!(perm&mrf::RawRegisterAccess::Write))
            throw std::runtime_error("Register not writable");
    }
    void check_read() const {
        if(!(perm&mrf::RawRegisterAccess::Read))
            throw std::runtime_error("Register not readable");
    }

    epicsUInt32 read8() const { check_read(); return ioread8(addr); }
    epicsUInt32 read16() const { check_read(); return nat_ioread16(addr); }
    epicsUInt32 read32() const { check_read(); return nat_ioread32(addr); }

    // TODO: RMW
    void write8(epicsUInt32 v) { check_write(); iowrite8(addr, v&0xff); }
    void write16(epicsUInt32 v) { check_write(); nat_iowrite16(addr, v&0xffff); }
    void write32(epicsUInt32 v) { check_write(); nat_iowrite32(addr, v); }
};

} // namespace

OBJECT_BEGIN(RawRegister)
  OBJECT_FACTORY(&RawRegister::buildReg);
  OBJECT_PROP2("UINT8" , &RawRegister::read8,  &RawRegister::write8);
  OBJECT_PROP2("UINT16", &RawRegister::read16, &RawRegister::write16);
  OBJECT_PROP2("UINT32", &RawRegister::read32, &RawRegister::write32);
OBJECT_END(RawRegister)
